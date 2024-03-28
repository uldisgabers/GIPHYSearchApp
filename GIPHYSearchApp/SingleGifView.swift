//
//  SingleGifView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 26/03/2024.
//

//import SwiftUI
//import WebKit
//
//struct SingleGifView: View {
//    let url: URL?
//    
//    var body: some View {
//        VStack {
////            Rectangle()
//            WebView(url: url)
//                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, minHeight: 0)
//                .border(Color.red)
////            Rectangle()
//        }
//    }
//}
//
//struct WebView: UIViewRepresentable {
//    let url: URL?
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        guard let url = url else { return }
//        let request = URLRequest(url: url)
//        uiView.load(request)
//    }
//}
//
//#Preview {
//    SingleGifView(url: URL(string: "https://giphy.com/embed/YmH7J2n6mZeE4VqOP4"))
//}

import SwiftUI
import WebKit
import FLAnimatedImage

struct SingleGifView: View {
//    let gifURL: URL
    
//    var body: some View {
//        WebView(request: URLRequest(url: gifURL))
//    }
    
    var body: some View {
        GIFView(type: .url(URL(string: "https://media1.giphy.com/media/cZ7rmKfFYOvYI/200.gif")!))
            .frame(width: 320, height: 200)
      }
    
    
}

struct WebView: UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}




#Preview {
    SingleGifView()
}
