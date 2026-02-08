import SwiftUI

struct StatisticsRowView: View {
    let index: Int
    let user: StatisticsUser

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            Text("\(index)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 24, alignment: .leading)

            HStack(spacing: 12) {
                Image(systemName: user.avatarSystemName ?? "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.secondary)

                Text(user.name)
                    .font(.headline)

                Spacer()

                Text("\(user.score)")
                    .font(.headline)

            }
            .padding(.horizontal, 16)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(Color.lightGrayDay)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

