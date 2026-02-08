//
//  RatingStars.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import SwiftUI

struct RatingStars: View {
    let rating: Int
    private let maxRating = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(index < rating ? .icStarSelected : .icStarUnselected)
            }
        }
    }
}
