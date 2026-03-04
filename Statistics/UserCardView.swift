import SwiftUI

struct UserCardView: View {
    
    let user: StatisticsUser
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack(spacing: 12) {
                    
                    if let avatarURL = user.avatarURL {
                        AsyncImage(url: avatarURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(user.name)
                        .font(.system(size: 22, weight: .bold))
                    
                    Spacer()
                }
                
                if let description = user.description,
                   !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Описание отсутствует")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                
                if let website = user.website,
                   let url = URL(string: website),
                   !website.isEmpty {
                    
                    Link(destination: url) {
                        Text("Перейти на сайт пользователя")
                            .font(.system(size: 17))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundStyle(Color(UIColor.textPrimary))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary, lineWidth: 1)
                    )
                }
                
                NavigationLink {
                    UserCollectionView(
                        title: "Коллекция NFT",
                        nftIds: user.nftIds,
                        service: StatisticsService(api: APIClient(baseURL: Secrets.baseURL))
                    )
                } label: {
                    HStack {
                        Text("Коллекция NFT (\(user.score))")
                            .font(.system(size: 17, weight: .bold))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color.white)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(24)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}
