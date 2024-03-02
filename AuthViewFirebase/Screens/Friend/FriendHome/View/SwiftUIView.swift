//
//  SwiftUIView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 24.02.2024.
//

import SwiftUI
/*
struct SwiftUIView: View {
    
    @State private var url: URL? = nil
    @ObservedObject var viewModelSettings: SettingsViewModel
    @ObservedObject var viewModel: FriendHomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        GeometryReader {_ in
            VStack(alignment: .center) {
                Spacer()
                
                HStack {
                    Spacer()
                    
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
                                .frame(width: 350, height: 350, alignment: .center)
                                .clipShape(Circle())
                                .padding(.horizontal)
                                .onTapGesture {
                                    dismiss()
                                }
                        case .failure:
                            Image(systemName: "wifi.slash")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    
                    Spacer()
                }
                
                    
                
                Spacer()
            }
            
            
        }
        .background(Color(.tertiarySystemFill))
        .task {
            self.url = try? await viewModelSettings.getUrlImageFriendAsync(id: viewModel.friend.userId)
        }
        
    }
}

//#Preview {
//    SwiftUIView()
//}
*/
