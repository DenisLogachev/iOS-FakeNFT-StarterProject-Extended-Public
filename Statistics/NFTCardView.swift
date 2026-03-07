import SwiftUI
import Foundation

struct NFTCardView: View {
    
    let nft: NFTItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topTrailing) {
                
                AsyncImage(url: URL(string: nft.images.first ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Image(systemName: "heart.fill")
                    .foregroundStyle(.white)
                    .padding(6)
            }
            
            ratingView
            
            HStack {
                
                VStack(alignment: .leading, spacing: 4) {

                    Text(nft.name)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 34)

                    Text("\(String(format: "%.2f", nft.price)) ETH")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "cart")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < nft.rating ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
    }
}
