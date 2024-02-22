//
//  ReservedPresentsCardFriendDataCell.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI


//struct ReservedPresentsCardFriendDataCell: View {
//    
//    @State private var flipped: Bool = true
//    
//    
//    var image = UIImage(named: "person")!
//    let friend: DBUser
//    
//    var body: some View {
//        
//        
//        VStack {
//            
//            ZStack {
//                Image("dayson")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 160)
//                    .clipped()
//                    .blur(radius: flipped ? 6 : 0)
//                
//                if flipped {
//                    Image("person")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: 110)
//                        .clipShape(Circle())
//                        .offset(y: 55)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .padding(.horizontal)
//                }
//             
//            }
//         
//            VStack {
//                Button(action: {
//                    withAnimation {
//                        flipped.toggle()
//                    }
//                }, label: {
//                    Text("Подробнее")
//                        .padding(.vertical, 4)
//                        .padding(.horizontal)
//                        .overlay {
//                            Capsule()
//                                .stroke(lineWidth: 2)
//                        }
//                })
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, 10)
//                
//                
//                HStack {
//                    Text(flipped ? friend.userName ?? "" : "Описание")
//                        .font(.title3.bold())
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading)
//                .padding(.bottom, -8)
//                
//                HStack {
////                    Text(flipped ? "present.name" : "present.presentDescription")
//                    Text(flipped ? "present.name" : "present.presentDescription")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding([.leading, .bottom])
//                }
//            }
//        }
//        .background(Color(.tertiarySystemFill))
//        .clipShape(RoundedRectangle(cornerRadius: 26))
//    }
//    
//    
//}
//
//#Preview {
//    ReservedPresentsCardFriendDataCell(friend: DBUser(id: "", userId: "", isAnonimous: true, email: "", photoUrl: "", dateCreated: Date(), isPremium: true, dateBirth: Date(), phoneNumber: "", displayName: "", userName: ""))
//}
