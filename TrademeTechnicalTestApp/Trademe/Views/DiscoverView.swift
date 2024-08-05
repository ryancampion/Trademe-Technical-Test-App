//
//  ContentView.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 02/08/2024.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject private var viewModel: DiscoverViewModel

    init(viewModel: DiscoverViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    struct Constants {
        static let cellHeight: CGFloat = 90
    }
    
    var body: some View {
        
        NavigationView {
            List(viewModel.listings) { listing in
                HStack(alignment: .top) {
                    
                    // MARK: - Listing Image
                    /// We first see if there is a photo URL, otherwise we use the pictureHref with live data.
                    /// Otherwise if we are using mock data we check to see if useLocalImage == true, and use the listing local image.
                    /// If all else fails we use a backup transparant Trademe logo image
                    Group {
                        if let urlString = listing.photoUrls.first ?? listing.pictureHref,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    backupPlaceholderImageView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else if listing.useLocalImage, 
                                    let localImage = listing.localImage {
                            Image(localImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            backupPlaceholderImageView()
                        }
                    }
                    .frame(width: Constants.cellHeight, height: Constants.cellHeight)
                    .cornerRadius(4)
                    .clipped()
                    
                    Spacer().frame(width: 10)
                    
                    // MARK: - Text Stack
                    VStack(alignment: .leading) {
                        
                        // MARK: - Listing Region
                        Text(listing.region ?? "Unknown")
                            .font(.system(size: 11))
                            .foregroundColor(.trademeColours.bluffOyster600)
                        
                        // MARK: - Listing Title
                        headingTextView(text: listing.title ?? "Unknown")
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        // MARK: - Listing Prices
                        /// If listing is classifed we show the priceDisplay on right
                        /// If not classified we show priceDisplay on left and buyNowPrice on right if available
                        if listing.isClassified {
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    headingTextView(text: listing.priceDisplay ?? "Unknown")
                                    subheadingTextView(text: "Buy Now")
                                }
                            }
                            
                        } else {
                            HStack {
                                VStack(alignment: .leading) {
                                    headingTextView(text: listing.priceDisplay ?? "Unknown")
                                    if listing.reserveState != 4 { // Reserve State 4 is "Not Applicable"
                                        subheadingTextView(text: {
                                            switch listing.reserveState {
                                            case 0:
                                                return "No Reserve"
                                            case 1:
                                                return "Reserve Met"
                                            case 2:
                                                return "Reserve Not Met"
                                            default:
                                                return ""
                                            }
                                        }())
                                    }
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    if let buyNowPrice = listing.buyNowPrice {
                                        let formattedPrice = String(format: "$%.2f", buyNowPrice)
                                        headingTextView(text: formattedPrice)
                                        subheadingTextView(text: "Buy Now")
                                    }
                                    
                                }
                            }
                        }
                    }
                    .frame(height: Constants.cellHeight,
                           alignment: .top)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Show a placeholder alert for listing
                    viewModel.selectedListing = listing
                    viewModel.alertType = .item
                    viewModel.showingAlert = true
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Browse")
            .navigationBarItems(trailing:
                HStack {
                
                    // MARK: - Navigation Search Button
                    Button(action: {
                        viewModel.alertType = .search
                        viewModel.showingAlert = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.trademeColours.tasman500)
                    }
                
                    // MARK: - Navigation Cart Button
                    Button(action: {
                        viewModel.alertType = .cart
                        viewModel.showingAlert = true
                    }) {
                        Image(systemName: "cart")
                            .foregroundColor(.trademeColours.tasman500)
                    }
                }
            )
            .alert(isPresented: $viewModel.showingAlert) {
                switch viewModel.alertType {
                case .item:
                    return Alert(
                        title: Text(viewModel.selectedListing?.title ?? "Listing"),
                        message: Text("Price: \(viewModel.selectedListing?.priceDisplay ?? "Unknown")\nLocation: \(viewModel.selectedListing?.region ?? "Unknown")"),
                        dismissButton: .default(Text("OK"))
                    )
                case .search:
                    return Alert(
                        title: Text("Search"),
                        message: Text("Search placeholder"),
                        dismissButton: .default(Text("OK"))
                    )
                case .cart:
                    return Alert(
                        title: Text("Cart"),
                        message: Text("Cart placeholder"),
                        dismissButton: .default(Text("OK"))
                    )
                case .networkError(let errorDesc):
                    return Alert(
                        title: Text("Network Error"),
                        message: Text(errorDesc),
                        dismissButton: .default(Text("OK"))
                    )
                case .none:
                    return Alert(title: Text("Unknown"))
                }
            }
        }
    }
    
    private func backupPlaceholderImageView() -> some View {
            // A semi transparant image of the trademe logo
            Image("listingBackupImage")
                .resizable()
                .scaledToFill()
                .frame(width: Constants.cellHeight,
                       height: Constants.cellHeight)
                .cornerRadius(4)
                .clipped()
                .opacity(0.3)
        }
    
    private func headingTextView(text: String) -> some View {
        // Sets to white for dark mode
        Text(text)
            .font(.system(size: 13, 
                          weight: .bold))
            .foregroundColor(Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark 
                ? .white : UIColor(Color.trademeColours.bluffOyster800)
                }))
    }
    
    private func subheadingTextView(text: String) -> some View {
        Text(text)
            .font(.system(size: 11))
            .foregroundColor(.trademeColours.bluffOyster600)
    }
}

#Preview {
    DiscoverView(viewModel:DiscoverViewModel(dataSource:MockListingDataSource()))
}
