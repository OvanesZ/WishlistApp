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
    @State private var url: URL? = nil
    
    
    var body: some View {
        
        
        HStack {
            
            KFImage(url)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            VStack {
                Text("Дата рождения:")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 25)
                    .padding(.horizontal, 20)
                
                if let date = viewModel.friend.dateBirth {
                    Text("\(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 25, alignment: .leading)
                        .padding(.horizontal, 20)
                }
               
                
//                if let date = viewModelSettings.friendDbUserPersonalData?.dateBirth {
//                    Text("\(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 25, alignment: .leading)
//                        .padding(.horizontal, 20)
//                }
                
            }
        }
        .task {
            self.url = try? await viewModelSettings.getUrlImageFriendAsync(id: viewModel.friend.userId)
        }
        .padding(.leading)
//        .task {
//            try? await viewModelSettings.loadFriendDBUserPersonalData(id: viewModel.friend.userId)
//        }
    }
}
