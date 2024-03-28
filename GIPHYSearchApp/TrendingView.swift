//
//  TrendingView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 24/03/2024.
//

import SwiftUI
import WebKit

struct TrendingView: View {
    @State private var gifs: [Gif] = []
    @State private var offset = 0
    
    //    var body: some View {
    //        List(gifs, id: \.id) { gif in
    //            GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
    //                .frame(width: CGFloat(Int(gif.images.fixed_width.width)!), height: CGFloat(Int(gif.images.fixed_width.height)!))
    //        }
    //        .onAppear {
    //            fetchData()
    //        }
    //    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(gifs.indices, id: \.self) { index in
                    let gif = gifs[index]
                    GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
                        .frame(width: CGFloat(Int(gif.images.fixed_width.width)! - 10), height: CGFloat(Int(gif.images.fixed_width.height)!) - 10)
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
        .onAppear() {
            fetchData()
        }
    }
    
    
    private func fetchData() {
        let apiKey = "xB9uaMEw3N66ZVGf6UNZlziT2ei7LH1c"
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

struct Gif: Identifiable, Decodable {
    let id: String
    var title: String
    let slug: String
    var images: Images
    
    struct Images: Decodable {
        var fixed_width: FixedWidth
        
        struct FixedWidth: Decodable {
            var url: String
            var width: String
            let height: String
        }
        
        enum CodingKeys: String, CodingKey {
            case fixed_width
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, images
    }
}


struct GiphyResponse: Decodable {
    let data: [Gif]
}



#Preview {
    TrendingView()
}
