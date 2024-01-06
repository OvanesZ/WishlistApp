//
//  SettingsPersonalDataView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 07.12.2023.
//

import SwiftUI

struct SettingsPersonalDataView: View {
    
    @State private var userName = ""
    @State private var dateBirth = Date()
    @State private var isAvatarlertPresented = false
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false
    @ObservedObject var viewModel: SettingsViewModel
    @StateObject private var profileViewModel: ProfileViewModel = ProfileViewModel(profile: UserModel(id: "", email: "", displayName: "", address: "", dateOfBirth: Date()))
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding()
//                .onAppear {
//                    self.viewModel.getImage()
//                }
                .task {
                    try? await self.viewModel.getImageAsync()
                }
                .overlay {
                    if viewModel.isLoadImage {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(2)
                    }
                }
                .onTapGesture {
                    isAvatarlertPresented.toggle()
                }
                .confirmationDialog("Откуда взять фотку", isPresented: $isAvatarlertPresented) {
                    Button {
                        showImagePickerLibrary.toggle()
                        
                    } label: {
                        Text("Галерея")
                    }
                    
                    Button {
                        showImagePickerCamera.toggle()
                        
                    } label: {
                        Text("Камера")
                    }
                }
                .sheet(isPresented: $showImagePickerLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image)
                }
                .sheet(isPresented: $showImagePickerCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: $viewModel.image)
                }
            
            Form {
                Section(header: Text("Настройки профиля")) {
                    
                    if viewModel.dbUser?.displayName == nil {
                        TextField("Имя и Фамилия", text: $userName)
                            .font(.body.bold())
                    }
                    
                    
                    
                    
                    DatePicker(selection: $dateBirth, displayedComponents: [.date]) {
                        Text("Дата рождения")
                    }
                    .datePickerStyle(.automatic)
                    .environment(\.locale, Locale.init(identifier: "ru_RU"))
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                let userPersonalData = PersonalDataDBUser(userId: viewModel.dbUser?.userId ?? "", friendsId: viewModel.dbUserPersonalData?.friendsId ?? [""], mySubscribers: viewModel.dbUserPersonalData?.mySubscribers ?? [""], dateBirth: dateBirth, requestFriend: viewModel.dbUserPersonalData?.requestFriend ?? [""], userName: userName, photoUrl: viewModel.dbUserPersonalData?.photoUrl)
                                
                                try await UserManager.shared.createNewPersonalDataUser(user: userPersonalData)
                                viewModel.uploadImageAsync()
                                
                                // сохранение изображения в кэш
                                viewModel.saveToCache(userIdForNameImage: viewModel.dbUser?.userId ?? "image")
                            }
                            
                            dismiss()
                        } label: {
                            Text("Подтвердить")
                        }
                        Spacer()
                    }
                }
            }
        }
        
        
    }
}

//#Preview {
//    SettingsPersonalDataView(viewModel: SettingsViewModel())
//}
