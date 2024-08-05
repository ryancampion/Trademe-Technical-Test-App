//
//  DiscoverViewModel.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 03/08/2024.
//

import SwiftUI
import Combine

protocol ListingDataSource {
    func fetchListings() -> AnyPublisher<[Listing], Error>
}

class DiscoverViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    @Published var showingAlert = false
    @Published var selectedListing: Listing?
    @Published var alertType: AlertType?
    
    enum AlertType {
        case item
        case search
        case cart
        case networkError(String)
    }

    private var cancellables = Set<AnyCancellable>()
    private let dataSource: ListingDataSource
    
    init(dataSource: ListingDataSource) {
        self.dataSource = dataSource
        fetchListings()
    }
    
    func fetchListings() {
        dataSource.fetchListings()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // OK
                    break
                case .failure(let error):
                    self.showingAlert = true
                    self.alertType = .networkError(error.localizedDescription)
                    self.listings = []
                }
            }, receiveValue: { listings in
                self.listings = listings
            })
            .store(in: &cancellables)
    }
}


