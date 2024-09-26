//
//  SettingView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 19.11.2023.
//

import SwiftUI
import Kingfisher

struct SettingView: View {
    
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var isQuitAlertPresented = false
    @State private var userName: String = ""
    @State private var showSettingsPersonalData = false
    @State private var isDeleteAccaunt = false
    @State private var isShowLiginView = false
    @State private var isShowSignInView = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Circle()
                    .overlay {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    .frame(width: 200, height: 200)
                
                Form {
                    
                    Section(header: Text("Профиль")) {
                        
                        if viewModel.authProviders.contains(.email) {
                            emailSection
                        }
                        
                        if viewModel.authProviders.contains(.google) {
                            googleSection
                        }
                        
                        if viewModel.authProviders.contains(.apple) {
                            googleSection
                        }
                        
                    }
                    
                    
                    Section {
                        Button(action: { isDeleteAccaunt = true }, label: {
                            HStack {
                                Spacer()
                                Text("Удалить аккаунт")
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                            
                        })
                        .fullScreenCover(isPresented: $isShowLiginView, content: {
                            AuthenticationView(showSignInView: $isShowSignInView)
                        })
                        .confirmationDialog("Вы точно хотите удалить аккаунт?", isPresented: $isDeleteAccaunt, titleVisibility: .visible) {
                            Button(role: .destructive) {
                                
                                viewModel.deletingAccaunt()
                                isShowLiginView = true
                                
                            } label: {
                                Text("Да")
                            }
                            
                        }
                    }
                    
                }
                
                
                .onAppear {
                    viewModel.loadAuthProviders()
                }
             
                .onDisappear {
                
                    
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
                            Button(role: .destructive) {
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
                            Task {
                                try await viewModel.getImageAsync()
                            }
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
            .task {
                try? await viewModel.loadCurrentDBUser()
                try? await viewModel.getImageAsync()
            }
            
            
            
          
        }
    }
    
}



extension SettingView {
    private var emailSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                if user.userName == nil && user.userSerName == nil {
                    Text(user.displayName ?? "")
                        .font(.system(.headline, design: .rounded))
                } else {
                    Text((user.userName ?? "") + " " + (user.userSerName ?? ""))
                        .font(.system(.headline, design: .rounded))
                }
                
//                Text((user.userName ?? "") + " " + (user.userSerName ?? ""))
//                    .font(.system(.headline, design: .rounded))
                    
                
                Text(user.email ?? "")
                    .font(.system(.callout, design: .rounded))
                
                if let date = user.dateBirth {
                    Text("Дата рождения: \(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.system(.callout, design: .rounded))
                }
                
            }
            
//            Button(action: {}, label: {
//                Text("Удалить аккаунт")
//                    .foregroundStyle(.red)
//            })
                
        }
    }
}


extension SettingView {
    private var googleSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                if user.userName == nil && user.userSerName == nil {
                    Text(user.displayName ?? "")
                        .font(.system(.headline, design: .rounded))
                } else {
                    Text((user.userName ?? "") + " " + (user.userSerName ?? ""))
                        .font(.system(.headline, design: .rounded))
                }
                
                Text(user.email ?? "")
                    .font(.system(.callout, design: .rounded))

                if let date = user.dateBirth {
                    Text("Дата рождения: \(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.system(.callout, design: .rounded))
                }
                
            }
        }
    }
}


extension SettingView {
    private var appleSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                if user.userName == nil && user.userSerName == nil {
                    Text(user.displayName ?? "")
                        .font(.system(.headline, design: .rounded))
                } else {
                    Text((user.userName ?? "") + " " + (user.userSerName ?? ""))
                        .font(.system(.headline, design: .rounded))
                }
                
                Text(user.email ?? "")
                    .font(.system(.callout, design: .rounded))

                if let date = user.dateBirth {
                    Text("Дата рождения: \(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.system(.callout, design: .rounded))
                }
                
            }
        }
    }
}
