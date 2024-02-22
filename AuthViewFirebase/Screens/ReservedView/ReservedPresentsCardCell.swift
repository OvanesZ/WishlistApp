//
//  ReservedPresentsCardCell.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI

struct ReservedPresentsCardCell: View {
   
    let present: PresentModel
    var image = UIImage(named: "person")!
    
    
    
    @State private var flippedCard: Bool = true
    @State private var friend: DBUser = DBUser(id: "", userId: "", isAnonimous: false, email: "", photoUrl: "", dateCreated: Date(), isPremium: false, dateBirth: Date(), phoneNumber: "", displayName: "", userName: "")
    @ObservedObject var viewModel: ReservedPresentsCardViewModel
    
    var body: some View {
        
        
        VStack {
            
            ZStack {
                
                
                Image("dayson")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
                    .blur(radius: flippedCard ? 6 : 0)
                
                if flippedCard {
                    Image("person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 110)
                        .clipShape(Circle())
                        .offset(y: 55)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                }
             
            }
         
            VStack {
                
                
                Button(action: {
                    
                    withAnimation {
                        flippedCard.toggle()
                    }
                    
                }, label: {
                    Text(flippedCard ? "Подробнее" : "Скрыть")
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                        .overlay {
                            Capsule()
                                .stroke(lineWidth: 2)
                                .foregroundStyle(.black)

                        }
                })
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 10)
                .padding(.bottom, 20)
                .padding(.top, 20)

                
                HStack {
                    Text(flippedCard ? (friend.userName ?? "") + " " + (friend.userSerName ?? "") : "Описание")
                        .font(.title3.bold())
                    
//                    Button(action: {
//                        
//                        withAnimation {
//                            flippedCard.toggle()
//                        }
//                        
//                    }, label: {
//                        Text(flippedCard ? "Подробнее" : "Скрыть")
//                            .padding(.vertical, 4)
//                            .padding(.horizontal)
//                            .overlay {
//                                Capsule()
//                                    .stroke(lineWidth: 2)
//                            }
//                    })
//                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
//                    .padding(.trailing, 10)
//                    .padding(.bottom, 20)
//                    .padding(.top, 20)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.bottom, -8)
                .task {
                    self.friend = try! await viewModel.getFriend(friendId: present.ownerId)
                }
                
                
                HStack {
                    Text(flippedCard ? present.name : present.presentDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom])
                    
                }
            }
        }
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 26))
      
        
    }
    
}

//#Preview {
//    ReservedPresentsCardCell()
//}
