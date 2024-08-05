//
//  LiveListingDataSource.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 04/08/2024.
//

import Foundation
import Combine

class LiveListingDataSource: ListingDataSource {
    
    struct Constants {
        static let trademeSandboxURLString = "https://api.tmsandbox.co.nz/v1/listings/latest.json"
        // Store API creds in Target Info to avoid hard coding
        static let consumerKey = Bundle.main.trademeSandboxAPIKey
        static let consumerSecret = Bundle.main.trademeSandboxAPISecret
    }
    
    func fetchListings() -> AnyPublisher<[Listing], Error> {
        
        // Add URL Params
        var components = URLComponents(string: Constants.trademeSandboxURLString)
        components?.queryItems = [
            URLQueryItem(name: "photo_size", value: "FullSize"), // Can be adjusted, Made full size so looked sharp when scaled on Listings
            URLQueryItem(name: "rows", value: "\(20)"), // Fetch only 20 listing
            URLQueryItem(name: "sort_order", value: "ExpiryDesc") // Fetch the latest listing
        ]
        
        // Check if URL is valid
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        let signature = "\(Constants.consumerSecret)&"
        
        // Add the OAuth1 Header info
        let authHeader = "OAuth oauth_consumer_key=\"\(Constants.consumerKey)\", "
                            + "oauth_signature_method=\"PLAINTEXT\", "
                            + "oauth_signature=\"\(signature)\""
        
        // Content Type Header
        request.addValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
    
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                // Check response code for error handling
                if let httpResponse = output.response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        // OK
                        break
                    case 401:
                        throw URLError(.userAuthenticationRequired)
                    default:
                        throw URLError(.badServerResponse)
                    }
                }
                return output.data
            }
            .decode(type: LatestListingsResponse.self,
                    decoder: JSONDecoder())
            .map { response in
                response.list.map { Listing(from: $0) }
            }
            .mapError { error in
                print("Network Error: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
}

struct LatestListingsResponse: Codable {
    let list: [ListingResponse]

    enum CodingKeys: String, CodingKey {
        case list = "List"
    }
}

// Note: Response Documentaion: http://developer.trademe.co.nz/api-reference/listing-methods/retrieve-latest-listings
struct ListingResponse: Codable {
    let id: Int?
    let title: String?
    let region: String?
    let photoUrls: [String]?
    let isClassified: Bool?
    let pictureHref: String?
    let priceDisplay: String?
    let buyNowPrice: Double?
    let reserveState: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ListingId"
        case title = "Title"
        case region = "Region"
        case photoUrls = "PhotoUrls"
        case isClassified = "IsClassified"
        case pictureHref = "PictureHref"
        case priceDisplay = "PriceDisplay"
        case buyNowPrice = "BuyNowPrice"
        case reserveState = "ReserveState"
    }
}

extension Listing {
    init(from response: ListingResponse) {
        self.id = response.id
        self.title = response.title
        self.region = response.region
        self.photoUrls = response.photoUrls ?? []
        self.isClassified = response.isClassified ?? false
        self.pictureHref = response.pictureHref
        self.priceDisplay = response.priceDisplay
        self.buyNowPrice = response.buyNowPrice
        self.reserveState = response.reserveState
        self.localImage = nil
        self.useLocalImage = false
    }
}

extension Bundle {
    var trademeSandboxAPIKey: String {
        return infoDictionary?["TrademeSandboxAPIKey"] as? String ?? "Not Found"
    }
    
    var trademeSandboxAPISecret: String {
        return infoDictionary?["TrademeSandboxAPISecret"] as? String ?? "Not Found"
    }
}
