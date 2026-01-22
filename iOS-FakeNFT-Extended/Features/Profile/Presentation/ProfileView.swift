//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(.ypWhite).ignoresSafeArea())

            if viewModel.isLoading, case .loaded = viewModel.state {
                Color.black.opacity(0.01).ignoresSafeArea()
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if case .loaded = viewModel.state {
                    Button { viewModel.path.append(.editProfile) } label: { Image(.icEdit) }
                }
            }
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loaded(let profile):
            VStack(alignment: .leading, spacing: 0) {
                header(profile: profile)
                description(profile: profile)
                website(profile: profile)
                menu(profile: profile)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)

        case .idle:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func header(profile: Profile) -> some View {
        HStack(alignment: .center, spacing: 16) {
            avatar(urlString: profile.avatar)
                .frame(width: 70, height: 70)
                .clipShape(Circle())

            Text(profile.name)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.ypBlack)
                .multilineTextAlignment(.leading)

        }
        .padding(.top, 16)
    }

    private func description(profile: Profile) -> some View {
        Text(profile.description ?? "Здесь пока ничего нет")
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.ypBlack)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
    }

    private func website(profile: Profile) -> some View {
        Button {
            if let url = URL(string: profile.website) {
                viewModel.path.append(.website(url))
            }
        } label: {
            Text(profile.website)
                .lineLimit(1)
                .truncationMode(.middle)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.ypBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }


    private func menu(profile: Profile) -> some View {
        List {
            Button { viewModel.path.append(.myNfts) } label: {
                ProfileMenuRowContent(title: "Мои NFT (\(profile.nfts.count))")
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)

            Button { viewModel.path.append(.favourites) } label: {
                ProfileMenuRowContent(title: "Избранные NFT (\(profile.likes.count))")
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .frame(height: 54 * 2)
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
    }

    private func avatar(urlString: String?) -> some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure, .empty:
                        placeholderAvatar
                    @unknown default:
                        placeholderAvatar
                    }
                }
            } else {
                placeholderAvatar
            }
        }
    }

    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color(.ypDarkGray))
            .frame(width: 70, height: 70)
    }
}

private struct ProfileMenuRowContent: View {
    let title: String

    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.ypBlack)

            Spacer(minLength: 0)

            Image(.icChevronForward)
                .frame(width: 54, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 54)
        .contentShape(Rectangle())
    }
}
