import SwiftUI

struct UserCardView: View {
    
    let user: StatisticsUser
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack(spacing: 12) {
                    Image(systemName: user.avatarSystemName ?? "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.secondary)
                    
                    Text(user.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                
                Text("Описание пользователя (заглушка для 1/3). Здесь будет текст из API во 2/3.")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button {
                } label: {
                    Text("Перейти на сайт пользователя")
                        .font(.system(size: 17, weight: .regular))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .foregroundStyle(.primary)
                
                NavigationLink {
                    UserCollectionView(title: "Коллекция NFT", count: user.score)
                } label: {
                    HStack {
                        Text("Коллекция NFT (\(user.score))")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color.white)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(24)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

