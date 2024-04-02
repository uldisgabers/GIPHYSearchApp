//
//  DetailedGifView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 30/03/2024.
//

import SwiftUI

struct DetailedGifView: View {
    
    @State private var orientation = UIDeviceOrientation.portrait
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    let gif: Gif
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    ScrollView {
                        Group {
                            if orientation.isPortrait {
                                
                                GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
                                    .frame(width: proxy.size.width, height: CGFloat(Int(gif.images.fixed_width.height)!) * proxy.size.width / CGFloat(Int(gif.images.fixed_width.width)!)) // formula to calculate the right height of the gif
                                    .scaledToFill()
                                
                                Text(gif.title)
                                    .font(.title)
                                
                            } else if orientation.isLandscape {
                                LazyVGrid(columns: columns) {
                                    
                                    GIFView(type: .url(URL(string: gif.images.fixed_width.url)!))
                                        .frame(width: proxy.size.width / 2, height: CGFloat(Int(gif.images.fixed_width.height)!) * proxy.size.width / 2 / CGFloat(Int(gif.images.fixed_width.width)!))
                                        .scaledToFill()
                                    
                                    Text(gif.title)
                                        .font(.title)
                                }
                            }
                        }
                        .onRotate { newOrientation in
                            orientation = newOrientation
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

#Preview {
    DetailedGifView(gif: Gif(id: "3o7qDLPScYgKRLu5NK", title: "q2 GIF by Audi", slug: "audi-q2-untaggable-audiq2-3o7qDLPScYgKRLu5NK", images: GIPHYSearchApp.Gif.Images(fixed_width: GIPHYSearchApp.Gif.Images.FixedWidth(url: "https://media1.giphy.com/media/3o7qDLPScYgKRLu5NK/200w.gif?cid=acdeecf45g8xus58nj3xs61gyf9mserry5a1nalnsglihd8f&ep=v1_gifs_search&rid=200w.gif&ct=g", width: "200", height: "200"))))
}
