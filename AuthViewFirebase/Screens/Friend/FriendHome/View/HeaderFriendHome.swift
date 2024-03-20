//
//  HeaderFriendHome.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI
import Kingfisher

struct HeaderFriendCell: View {
    
    @ObservedObject var viewModel: FriendHomeViewModel
    @State private var isLoadImage = false
    @State private var url: URL? = nil
    
    
    var body: some View {
        
        
        HStack {
            
            AsyncImage(
                url: url,
                transaction: Transaction(animation: .linear)
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    EmptyView()
                }
            }
            
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
            }
        }
        .task {
            self.url = try? await viewModel.getUrlImageFriendAsync(id: viewModel.friend.userId)
        }
        .padding(.leading)
    }
}
