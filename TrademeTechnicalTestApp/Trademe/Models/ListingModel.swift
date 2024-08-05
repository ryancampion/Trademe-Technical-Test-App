//
//  ListingModel.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 03/08/2024.
//

import Foundation

struct Listing: Identifiable {
    let id: Int?
    let title: String?
    let region: String?
    let photoUrls: [String]
    let isClassified: Bool
    let pictureHref: String?
    let priceDisplay: String?
    let buyNowPrice: Double?
    let reserveState: Int?
    let localImage: String?
    let useLocalImage: Bool
}
