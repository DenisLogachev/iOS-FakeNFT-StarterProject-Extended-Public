import SwiftUI

struct StatisticsRowView: View {
    let index: Int
    let user: StatisticsUser
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            Text("\(index)")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .leading)
            
            HStack(spacing: 12) {
                
                if let avatarURL = user.avatarURL {
                    AsyncImage(url: avatarURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.secondary)
                }
                
                Text(user.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(user.score)")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.horizontal, 16)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(Color.lightGrayDay)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
