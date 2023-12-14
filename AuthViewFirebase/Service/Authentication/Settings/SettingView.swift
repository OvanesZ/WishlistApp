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
    @State private var url: URL? = nil
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Circle()
                    .frame(width: 200, height: 200)
                    .overlay {
                            AsyncImage(
                                url: url,
                                transaction: Transaction(animation: .linear)
                            ) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .transition(.scale(scale: 0.1, anchor: .center))
                                case .failure:
                                    Image(systemName: "wifi.slash")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 200, height: 200)
                            .background(Color.gray)
                            .clipShape(Circle())
                        
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 200, height: 200)
//                            .clipShape(Circle())
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
                .refreshable(action: {
                    self.url = try? await viewModel.getUrlImageAsync()
//                    try? await viewModel.loadCurrentDBUserPersonalData()

                })
                
                
                .onAppear {
                    viewModel.loadAuthProviders()
                }
                .task {
                    try? await viewModel.loadCurrentDBUser()
                    try? await viewModel.loadCurrentDBUserPersonalData()
                    self.url = try? await viewModel.getUrlImageAsync()
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
