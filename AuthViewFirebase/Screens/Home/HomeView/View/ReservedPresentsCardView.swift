//
//  ReservedPresentsCardView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 15.02.2024.
//

import SwiftUI

struct ReservedPresentsCardView: View {
    
    private var testPresent: [PresentModel] = [
    PresentModel(id: "1", name: "Present 1", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "2", name: "Present 2", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "3", name: "Present 3", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "4", name: "Present 4", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "5", name: "Present 5", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "6", name: "Present 6", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "7", name: "Present 7", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "8", name: "Present 8", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1")
    ]
    
    
    var body: some View {
        
//        List(testPresent) { present in
//            
//            ReservedPresentsCardCell(present: present)
//                .listRowSeparator(.hidden)
//            
//        }
//        .listStyle(.plain)
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                ForEach(testPresent) { present in
                    
                    ReservedPresentsCardCell(present: present)
                        .padding(6)
                    
                }
                
            }
        }
        
        
        
    }
}

#Preview {
    ReservedPresentsCardCell( present: PresentModel(name: "Present", urlText: "", presentFromUserID: ""))
}


struct ReservedPresentsCardCell: View {
    
    @State private var flipped = true
    var image = UIImage(named: "person")!
    let present: PresentModel
    
    var body: some View {
        
        
        VStack {
            
            ZStack {
                Image("dayson")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
                    .blur(radius: flipped ? 6 : 0)
                
                if flipped {
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
                        flipped.toggle()
                    }
                }, label: {
                    Text("Подробнее")
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .overlay {
                            Capsule()
                                .stroke(lineWidth: 2)
                        }
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                
                
                HStack {
                    Text(flipped ? "User 1" : "Описание")
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.bottom, -8)
                
                HStack {
                    Text(flipped ? present.name : "Пылесос Dayson")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom])
                    
                    
                }
              
                
                
                
            }
            
            
        }
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        
        
        
   
        
//        RoundedRectangle(cornerRadius: 6)
//            .fill(flipped ? Color.orange : Color.purple)
//            .frame(height: 120)
//            .overlay {
//                ZStack {
//                    HStack {
//                        Spacer()
//                        VStack {
//                            Image(uiImage: image)
//                            Spacer()
//                        }
//                    }
//                    Text(present.name)
//                        .foregroundColor(flipped ? Color.black : Color.orange)
//                        .font(.title.bold())
//                }.padding()
//            }
//            .onTapGesture {
//                withAnimation {
//                    flipped.toggle()
//                }
//            }
    }
    
}
