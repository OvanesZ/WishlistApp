//
//  CreateNameView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 27.01.2024.
//

import SwiftUI
import Kingfisher

struct CreateNameView: View {
    
    @State private var userName = ""
    @State private var userSername = ""
    @State private var isPresentRoot = false
    @State private var dateBirth = Date()
    @State private var isImageAlert = false
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false
    @Binding var showSignInView: Bool
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    
                    HStack {
                        Text("Добро пожаловать!")
                            .font(.system(.title, design: .default))
                            .padding()
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    HStack {
                        
                        if viewModel.authProviders.contains(.apple) {
                            Text("Укажите, пожалуйста, Вашу дату рождения и выберете аватарку")
                                .font(.system(.subheadline, design: .default))
                                .padding()
                                .foregroundColor(.white)
                            
                            Spacer()
                        } else {
                            Text("Укажите, пожалуйста, Ваше имя, фамилию и дату рождения и выберете аватарку")
                                .font(.system(.subheadline, design: .default))
                                .padding()
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                       
                    }
                    .padding(.top, -25)
                    
                    
                    Spacer()
                    
                    Section {
                        
                        Circle()
                            .overlay {
                                Image(uiImage: viewModel.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 200, height: 200)
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                            .onTapGesture {
                                isImageAlert.toggle()
                            }
                            .confirmationDialog("Откуда взять фотографию?", isPresented: $isImageAlert) {
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
                        
                        if viewModel.authProviders.contains(.apple) {
                            
                            
                            
                        } else {
                            TextField("", text: $userName, prompt: Text("Имя").foregroundColor(.gray))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundStyle(.black)
                            
                            TextField("", text: $userSername, prompt: Text("Фамилия").foregroundColor(.gray))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .foregroundStyle(.black)
                        }
                                                
                        DatePicker(selection: $dateBirth, displayedComponents: [.date]) {
                            Text("Дата рождения")
                                .foregroundStyle(.white)
                                .font(.callout.bold())
                                .padding()
                        }
                        .datePickerStyle(.automatic)
                        .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    }
                    
                    
                    VStack {
                        
                        if viewModel.authProviders.contains(.apple) {
                            Spacer()
                                .padding(.bottom, 160)
                        } else {
                            
                        }
                       
                        
                        Button {
                            
                            Task {
                                let userPersonalData = PersonalDataDBUser(userId: AuthService.shared.currentUser?.uid ?? "", friendsId: viewModel.dbUserPersonalData?.friendsId ?? [""], mySubscribers: viewModel.dbUserPersonalData?.mySubscribers ?? [""], requestFriend: viewModel.dbUserPersonalData?.requestFriend ?? [""])
                                
                                try await UserManager.shared.createNewPersonalDataUser(user: userPersonalData)
                            }
                            viewModel.uploadImageAsync(userID: AuthService.shared.currentUser?.uid ?? "")
                            UserDefaults.standard.setValue(false, forKey: AuthService.shared.currentUser?.uid ?? "NewUser")
                            viewModel.updateUserName(userName: userName, userSerName: userSername)
                            viewModel.updateDateBirth(dateBirth: dateBirth)
                            isPresentRoot = true
                            showSignInView = false
                        } label: {
                            Text("Далее")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color("testColor"))
                                .cornerRadius(10)
                        }
                        .disabled(userName.isEmpty && userSername.isEmpty)
                        .padding(.top, 35)
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $isPresentRoot, content: {
                RootView()
            })
            .padding()
            .background {
                Image("bg_wishlist")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            }
            
            
        }
        .sheet(isPresented: $showImagePickerLibrary, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image)
        })
        .sheet(isPresented: $showImagePickerCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.image)
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }

        
    }
}




//#Preview {
//    CreateNameView(showSignInView: .constant(false))
//}
