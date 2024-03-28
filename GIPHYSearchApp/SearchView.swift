//
//  SearchView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 25/03/2024.
//

import SwiftUI

struct SearchView: View {
    
    @State private var gifs: [Gif] = []
    @State private var offset = 0
    @State private var searchText: String = ""
    @State private var hasTimeElapsed = false
    @State var value = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            
            
            Text("Search something!!!")
            
            //        TextField(
            //            "Type what you are looking for...", text: $searchText
            //        )
            //        .padding()
            //        .textInputAutocapitalization(.never)
            //        .disableAutocorrection(true)
            //        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.892))
            //        .cornerRadius(10)
            //        .padding()
            //        .onChange(of: searchText, perform: )
            
            
            DebounceTextField(label: "Search GIFs...", value: $value) { value in
                self.gifs = []
                self.offset = 0
                fetchData()
            }
            .padding()
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.892))
            .cornerRadius(10)
            .padding()
            
            //
            //        Button {
            //            self.gifs = []
            //            self.offset = 0
            //            fetchData()
            //        } label: {
            //            Text("Search")
            //        }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(gifs.indices, id: \.self) { index in
                        let gif = gifs[index]
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
                .padding(.horizontal, 5.0)
            }
        }
        
    }
    
    private func delayText() async {
        // Delay of 1.5 seconds
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        hasTimeElapsed = true
        fetchData()
    }
    
    private func fetchData() {
        let apiKey = "xB9uaMEw3N66ZVGf6UNZlziT2ei7LH1c"
        let urlString = "https://api.giphy.com/v1/gifs/search"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        let limitQueryItem = URLQueryItem(name: "limit", value: "25") // how much itemes to load on a single fetch (i.e. = 25)
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let qQueryItem = URLQueryItem(name: "q", value: "\(value)") // search fraze to pass in req params
        
        urlComponents.queryItems = [apiKeyQueryItem, limitQueryItem, offsetQueryItem, qQueryItem]
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
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
    SearchView()
}
