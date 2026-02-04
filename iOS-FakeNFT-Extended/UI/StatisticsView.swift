import Foundation
import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { index in
                    HStack(spacing: 12) {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                        
                        VStack(alignment: .leading) {
                            Text("User \(index)")
                                .font(.headline)
                            Text("NFT count")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(index * 10)")
                            .bold()
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

