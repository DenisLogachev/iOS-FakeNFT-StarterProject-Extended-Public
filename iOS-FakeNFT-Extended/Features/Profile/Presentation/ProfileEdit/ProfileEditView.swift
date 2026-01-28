//
//  ProfileEditView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 28.01.2026.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ProfileEditViewModel

    @State private var isPhotoDialogPresented = false
    @State private var isPhotoURLAlertPresented = false
    @State private var photoURLText = ""

    init(viewModel: ProfileEditViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(.ypWhite).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    header

                    field(title: NSLocalizedString("Profile.edit.name.title", comment: "")) {
                        TextField("", text: $viewModel.draft.name)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.ypBlack)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                    }
                    .padding(.top, 24)

                    field(title: NSLocalizedString("Profile.edit.description.title", comment: "")) {
                        TextField("", text: $viewModel.draft.description, axis: .vertical)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.ypBlack)
                            .lineLimit(3...6)
                    }
                    .padding(.top, 24)

                    field(title: NSLocalizedString("Profile.edit.website.title", comment: "")) {
                        TextField("", text: $viewModel.draft.website)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.ypBlack)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 2)
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.hasChanges {
                    saveButton
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                        .background(Color(.ypWhite).ignoresSafeArea(edges: .bottom))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.15), value: viewModel.hasChanges)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Image(.icBackward) }
            }
        }
        .confirmationDialog(
            NSLocalizedString("Profile.edit.photo.title", comment: ""),
            isPresented: $isPhotoDialogPresented,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("Profile.edit.photo.change", comment: "")) {
                photoURLText = ""
                isPhotoURLAlertPresented = true
            }

            Button(NSLocalizedString("Profile.edit.photo.delete", comment: ""), role: .destructive) {
                viewModel.removeAvatar()
            }

            Button(NSLocalizedString("Common.cancel", comment: ""), role: .cancel) { }
        }
        .alert(
            NSLocalizedString("Profile.edit.photo.url.title", comment: ""),
            isPresented: $isPhotoURLAlertPresented
        ) {
            TextField("https://", text: $photoURLText)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)

            Button(NSLocalizedString("Common.cancel", comment: ""), role: .cancel) { }

            Button(NSLocalizedString("Common.save", comment: "")) {
                viewModel.setAvatarURL(from: photoURLText)
            }
        }
        .overlay {
            if viewModel.isSaving {
                ZStack {
                    Color.black.opacity(0.01)
                        .ignoresSafeArea()
                        .allowsHitTesting(true)

                    ProgressView()
                }
            }
        }
    }

    private var header: some View {
        Button { isPhotoDialogPresented = true } label: {
            ZStack(alignment: .bottomTrailing) {
                avatarView
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                Image(.icCamera)
                    .padding(6)
                    .background(Color(.ypLightGray))
                    .clipShape(Circle())
                    .offset(x: 2, y: 2)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var avatarView: some View {
        Group {
            if let url = viewModel.draft.avatarRemoteURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
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
    }

    private func field<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.ypBlack)

            content()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.ypLightGray))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var saveButton: some View {
        Button {
            Task {
                await viewModel.save()
                dismiss()
            }
        } label: {
            Text(NSLocalizedString("Common.save", comment: ""))
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.ypWhite))
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.ypBlack))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isSaving || !viewModel.hasChanges)
        .opacity((viewModel.isSaving || !viewModel.hasChanges) ? 0.6 : 1)
    }
}
