//
//  ReservedPresentsCardCell.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI
import Kingfisher

struct ReservedPresentsCardCell: View {
   
    let present: PresentModel
    private let nameTextUrl: String = "[Ссылка на подарок]"
    
    @State private var image = UIImage(named: "person")!
    @State private var url: URL? = nil
    @State private var urlFriendImage: URL? = nil
    @State private var flippedCard: Bool = true
    @State private var friend: DBUser = DBUser(id: "", userId: "", isAnonimous: false, email: "", photoUrl: "", dateCreated: Date(), isPremium: false, dateBirth: Date(), phoneNumber: "", displayName: "", userName: "")
    @ObservedObject var viewModel: ReservedPresentsCardViewModel
    
    var body: some View {
        
        
        VStack {
            
            ZStack {
                
                KFImage(url)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
                    .blur(radius: flippedCard ? 6 : 0)
                
                if flippedCard {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 115, height: 115)
                        .offset(y: 55)
                        .overlay {
                            KFImage(urlFriendImage)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .offset(y: 55)
                                .frame(alignment: .center)
                                .padding(.horizontal)
                        }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        flippedCard.toggle()
                    }
                } label: {
                    Text(flippedCard ? "Подробнее" : "Скрыть")
                        .padding([.top, .bottom, .trailing, .leading], 4)
                        .font(.callout.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .background(Color.gray)
                        .opacity(0.85)
                        .cornerRadius(16)
                        .padding()
                }
            }
         
            VStack {

                HStack {
                    Text(flippedCard ? (friend.userName ?? "") + " " + (friend.userSerName ?? "") : "Описание")
                        .font(.title3.bold())
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.bottom, -8)
                .padding(.top, 25)
                .task {
                    self.friend = try! await viewModel.getFriend(friendId: present.ownerId)
                    self.url = try? await viewModel.getUrlPresentImage(presentId: present.id)
                    self.urlFriendImage = try? await viewModel.getUrlFriendImage(friendId: present.ownerId)
                }
                
               
             
                
                
                HStack {
                    Text(flippedCard ? present.name : present.presentDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom])
                }
                
                if !flippedCard {
                    HStack {
                        Text(.init(nameTextUrl+"(\(present.urlText))"))
                            .underline()
                            .padding(.leading, 15)
                        Spacer()
                    }
                    .padding(.bottom, 6)
                }
                
            }
            
        }
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 26))
//        .onDisappear {
//            ImageCache.default.clearCache()
//        }
     
        
      
        
    }
    
}

//#Preview {
//    ReservedPresentsCardCell()
//}
