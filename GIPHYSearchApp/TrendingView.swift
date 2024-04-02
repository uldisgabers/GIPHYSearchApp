//
//  TrendingView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 24/03/2024.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct TrendingView: View {
    @State var gifs: [Gif] = []
    @State var offset = 0
    @State private var orientation = UIDeviceOrientation.portrait
    @State private var isErrorOccurred = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    if orientation.isPortrait {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(gifs.indices, id: \.self) { index in
                                let gif = gifs[index]
                                NavigationLink {
                                    DetailedGifView(gif: gif)
                                } label: {
                                    GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
                                        .frame(width: CGFloat(Int(gif.images.fixed_width.width)! - 10), height: CGFloat(Int(gif.images.fixed_width.height)!) - 10)
                                        .id(index) // Add id parameter with unique index
                                        .onAppear {
                                            if index == gifs.count - 1 {
                                                offset += 25
                                                fetchData()
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 5.0)
                    } else if orientation.isLandscape {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(gifs.indices, id: \.self) { index in
                                let gif = gifs[index]
                                NavigationLink {
                                    DetailedGifView(gif: gif)
                                    
                                } label: {
                                    GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
                                        .frame(width: CGFloat(Int(gif.images.fixed_width.width)! - 20), height: CGFloat(Int(gif.images.fixed_width.height)!) - 20)
                                        .id(index) // Add id parameter with unique index
                                        .onAppear {
                                            if index == gifs.count - 1 {
                                                offset += 25
                                                fetchData()
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 5.0)
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
            }
            .alert(isPresented: $isErrorOccurred) {
                Alert(
                    title: Text("Error"),
                    message: Text("Failed to fetch data."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear() {
                fetchData()
            }
        }
    }
    
    
    func fetchData() {
        let apiKey = Secrets.apiKey
        let urlString = "https://api.giphy.com/v1/gifs/trending"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        let limitQueryItem = URLQueryItem(name: "limit", value: "25") // how much itemes to load on a single fetch (i.e. = 25)
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        
        urlComponents.queryItems = [apiKeyQueryItem, limitQueryItem, offsetQueryItem]
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                isErrorOccurred = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                isErrorOccurred = true
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(GiphyResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.gifs.append(contentsOf: response.data)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}


#Preview {
    TrendingView()
}
