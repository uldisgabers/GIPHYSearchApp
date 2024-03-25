//
//  ContentView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 24/03/2024.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var gifs: [Gif] = []
    
    var body: some View {
        NavigationView {
            List(gifs, id: \.id) { gif in
                VStack(alignment: .leading) {
                    Text(gif.title)
                        .font(.headline)
                    // Display GIF using WebView
                    if let embedURL = URL(string: gif.embed_url) {
                        WebView(url: embedURL)
                            .frame(height: 200)
                    }
                }
            }
            .onAppear {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        let apiKey = "xB9uaMEw3N66ZVGf6UNZlziT2ei7LH1c"
        let urlString = "https://api.giphy.com/v1/gifs/trending?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
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
                        self.gifs = response.data
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
    let embed_url: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, embed_url
    }
}

struct GiphyResponse: Decodable {
    let data: [Gif]
}

struct WebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



#Preview {
    ContentView()
}
