//
//  GIPHYSearchAppApp.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 24/03/2024.
//

import SwiftUI

@main
struct GIPHYSearchAppApp: App {
    var body: some Scene {
        WindowGroup {
            
//            ContentView()
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
}

