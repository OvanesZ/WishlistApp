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
                    }
                  
                
                
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
                    
                    
                }
                .refreshable(action: {
                    self.url = try? await viewModel.getUrlImageAsync()

                })
                
                
                .onAppear {
                    viewModel.loadAuthProviders()
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
                self.url = try? await viewModel.getUrlImageAsync()
            }
          
        }
        
    }
    
}



extension SettingView {
    private var emailSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                Text(user.userName ?? "")
                    .font(.system(.headline, design: .rounded))
                
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
    private var googleSection: some View {
        
        Section {
            if let user = viewModel.dbUser {
                
                Text(user.userName ?? "")
                    .font(.system(.headline, design: .rounded))
                
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
                
                Text(user.userName ?? "")
                    .font(.system(.headline, design: .rounded))
                
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
