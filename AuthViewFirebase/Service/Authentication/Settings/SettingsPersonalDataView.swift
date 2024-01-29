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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding()
                .task {
                    try? await self.viewModel.getImageAsync()
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
                    
                    TextField("Имя и Фамилия", text: $userName)
                        .font(.body.bold())
                        .textInputAutocapitalization(.words)
                    
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
                                viewModel.uploadImageAsync(userID: viewModel.currentUser?.uid ?? "")
                                try? await viewModel.loadCurrentDBUser()
                            }
                            
                            viewModel.updateDateBirth(dateBirth: dateBirth)
                            viewModel.updateUserName(userName: userName)
                            
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
