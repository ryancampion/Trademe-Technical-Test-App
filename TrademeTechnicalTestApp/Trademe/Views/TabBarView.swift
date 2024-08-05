//
//  TabBarView.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 02/08/2024.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    
    let dataSource: ListingDataSource

    var body: some View {
        
        TabView{
            DiscoverView(viewModel: DiscoverViewModel(dataSource: dataSource))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
            
            PlaceholderView(text: "Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            PlaceholderView(text: "Watchlist")
                .tabItem {
                    Image(systemName: "binoculars")
                    Text("Watchlist")
                }
            
            PlaceholderView(text: "My Trademe")
                .tabItem {
                    Image(systemName: "person")
                    Text("My Trademe")
                }
        }.accentColor(.trademeColours.tasman500)
    }
}

#Preview {
    TabBarView(dataSource: MockListingDataSource())
}
