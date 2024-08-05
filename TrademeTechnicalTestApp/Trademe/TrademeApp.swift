//
//  TrademeTechnicalTestAppApp.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 02/08/2024.
//

import SwiftUI

@main
struct TrademeApp: App {
    var body: some Scene {
        WindowGroup {
            // Dependancy Inject the Data Source into the depending on the scheme selected
            TabBarView(dataSource: createDataSource())
        }
    }
    
    func createDataSource() -> ListingDataSource {
            #if LIVE
                return LiveListingDataSource()
            #elseif MOCK
                return MockListingDataSource()
            #else
                fatalError("No valid configuration found for Schema")
            #endif
        }
}
