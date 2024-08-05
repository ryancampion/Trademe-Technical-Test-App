//
//  PlaceHolderView.swift
//  TrademeTechnicalTestApp
//
//  Created by Ryan Campion on 02/08/2024.
//

import Foundation
import SwiftUI

struct PlaceholderView: View {
    var text: String

    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.largeTitle).bold()
            Spacer()
        }
    }
}

#Preview {
    PlaceholderView(text: "Test")
}
