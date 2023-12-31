//
//  HeaderFriendHome.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI
import Kingfisher

struct HeaderFriendCell: View {
    
    @StateObject private var viewModelSettings: SettingsViewModel = SettingsViewModel()
    @ObservedObject var viewModel: FriendHomeViewModel
    @State private var isLoadImage = false
    
    
    var body: some View {
        
        
            HStack {
                
                Image(uiImage: viewModel.uiImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay {
                        if isLoadImage {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(2)
                        }
                    }
                
                
                VStack {
                    Text("Дата рождения:")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                        .padding(.horizontal, 20)
                    
                    if let date = viewModelSettings.friendDbUserPersonalData?.dateBirth {
                        Text("\(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 25, alignment: .leading)
                            .padding(.horizontal, 20)
                    }
                    
                }
            }
        
        
        
            .onFirstAppear {
                
                isLoadImage = true
                
                StorageService.shared.downloadUserImage(id: viewModel.friend.userId) { result in
                    switch result {
                    case .success(let data):
                        isLoadImage = false
                        if let img = UIImage(data: data) {
                            viewModel.uiImage = img
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            .padding(.leading)
            .task {
                try? await viewModelSettings.loadFriendDBUserPersonalData(id: viewModel.friend.userId)
            }
    }
}
