//
//  ProfileView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI
import Combine
//import PhotosUI

struct ProfileView: View {
    
    //MARK: - @State
    
    @State private var isAvatarlertPresented = false
    @State private var isQuitAlertPresented = false
    @State private var isAuthViewPresented = false
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false
    
    //MARK: - @StateObject
    
    @StateObject var viewModel: ProfileViewModel
    @StateObject private var viewModelPhotoPicker = PhotoPickerViewModel()
    
    //MARK: - Binding
    
    @Binding var showSignInView: Bool
    
    //MARK: - let
    
    private let keyboardPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in true } ,
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { notification in false }
    ).eraseToAnyPublisher()
    
    
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                // MARK: - Image Picker
                
                
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isQuitAlertPresented.toggle()
                            } label: {
                                HStack {
                                    Text("Выйти")
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                }
                                .font(.body.bold())
                                
                            }
                            .confirmationDialog("Выйти из аккаунта?", isPresented: $isQuitAlertPresented, titleVisibility: .visible) {
                                Button {
//                                    isAuthViewPresented.toggle()
                                    Task {
                                        do {
                                            try viewModel.signOut()
                                            showSignInView = true
                                        } catch {
                                            print(error)
                                        }
                                    }
                                } label: {
                                    Text("Да")
                                }
                            }
//                            .fullScreenCover(isPresented: $isAuthViewPresented, onDismiss: nil) {
//                                AuthView()
//                            }
                            
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
                        
                        TextField("Имя и Фамилия", text: $viewModel.profile.displayName)
                            .font(.body.bold())
                        
                        
                        HStack {
                            Text("+7")
                            TextField("Телефон", value: $viewModel.profile.phoneNumber, format: .number)
                                .keyboardType(.phonePad)
                        }
                        
                        DatePicker(selection: $viewModel.profile.dateOfBirth, displayedComponents: [.date]) {
                            Text("Дата рождения")
                        }
                        .datePickerStyle(.automatic)
                        .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    }
                    
                    
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                viewModel.setProfile()
                                isShowAlert.toggle()
                                alertMessage = "Успешно!"
                            } label: {
                                Text("Подтвердить")
                            }
                            .alert(alertMessage, isPresented: $isShowAlert) {
                                Button {
                                    
                                } label: {
                                    Text("OK!")
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        // Нажатие кнопки Return на клавиатуре
        .onSubmit {
            //            viewModel.setProfile()
        }
        .onAppear {
            self.viewModel.getProfile()
            self.viewModel.getImage()
        }
        
        
        
        
        
    }
    
    
    
    
}
