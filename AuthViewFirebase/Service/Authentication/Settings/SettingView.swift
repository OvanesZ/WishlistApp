//
//  SettingView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 19.11.2023.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var isQuitAlertPresented = false
    @State private var userName: String = ""
    @State private var showSettingsPersonalData = false
    @State private var id = UUID()
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Circle()
                    .frame(width: 200, height: 200)
                    .overlay {
                        
                        if viewModel.dbUserPersonalData?.photoUrl != nil {
                            
                            if let url = viewModel.dbUserPersonalData?.photoUrl {
                                
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 200, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                            }
                            
                        } else {
                            
                            if let url = viewModel.dbUser?.photoUrl {
                                
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 200, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                  
                
                
                Form {
                    
                    Section(header: Text("Профиль")) {
                        
                        if viewModel.authProviders.contains(.email) {
                            emailSection
                        }
                        
                        if viewModel.authProviders.contains(.google) {
                            googleSection
                        }
                        
                    }
                    
                }
                
                
                .onAppear {
                    viewModel.loadAuthProviders()
                }
                .task {
                    try? await self.viewModel.loadCurrentDBUser()
                    try? await self.viewModel.loadCurrentDBUserPersonalData()
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
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showSettingsPersonalData = true
                        } label: {
                            HStack {
                                Text("Редактировать")
                                Image(systemName: "gear")
                            }
                            .font(.body.bold())
                        }
                    }
                    
                    
                }
                .sheet(isPresented: $showSettingsPersonalData, onDismiss: nil) {
                    SettingsPersonalDataView(viewModel: viewModel)
                }
            }
          
        }
    }
    
    
}



extension SettingView {
    private var emailSection: some View {
//        Section {
//            Button("Сбросить пароль") {
//                Task {
//                    do {
//                        try await viewModel.resetPassword()
//                        print("Password reset!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            
//            Button("Обновить пароль") {
//                Task {
//                    do {
//                        try await viewModel.updatePassword()
//                        print("Password reset!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            
//            Button("Обновить email") {
//                Task {
//                    do {
//                        try await viewModel.updateEmail()
//                        print("Password reset!")
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        } header: {
//            Text("Функции электронной почты")
//        }
        Section {
            if let user = viewModel.dbUser {
                
                Text(user.displayName ?? viewModel.dbUserPersonalData?.userName ?? "")
                    .font(.title2.bold())
                
                Text(user.email ?? "")
                    .font(.title2)
                
                
                
            }
            
            if let userPersonalData = viewModel.dbUserPersonalData {
                if let date = userPersonalData.dateBirth {
                    Text("Дата рождения: \(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.headline)
                }
            }
            
            
            
        }
        
    }
}


extension SettingView {
    private var googleSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                Text(user.displayName ?? "")
                    .font(.title2.bold())
                
                Text(user.email ?? "")
                    .font(.title2)
                
                
            }
            
            if let userPersonalData = viewModel.dbUserPersonalData {
                if let date = userPersonalData.dateBirth {
                    Text("Дата рождения: \(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.headline)
                }
            }
            
            
            
        }
    }
}
