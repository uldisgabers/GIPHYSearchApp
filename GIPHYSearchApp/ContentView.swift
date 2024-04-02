//
//  ContentView.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 24/03/2024.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            TrendingView()
                .tabItem {
                    Label("Trending", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView()
}
