import Foundation
import SwiftUI

struct UserCardView: View {

    let user: StatisticsUser

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: user.avatarSystemName ?? "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .foregroundStyle(.secondary)

                Text(user.name)
                    .font(.title2)
                    .bold()

                Spacer()
            }

            Text("Описание пользователя (заглушка для 1/3). Здесь будет текст из API во 2/3.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                // 1/3: заглушка
            } label: {
                Text("Перейти на сайт пользователя")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            NavigationLink {
                UserCollectionView(title: "Коллекция NFT", count: user.score)
            } label: {
                HStack {
                    Text("Коллекция NFT (\(user.score))")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("User Card")
        .navigationBarTitleDisplayMode(.inline)
    }
}
