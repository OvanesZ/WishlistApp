//
//  PresentCellViewOtherList.swift
//  Wishlist
//
//  Created by Ованес Захарян on 06.09.2025.
//

import SwiftUI
import Kingfisher

struct PresentCellViewOtherList: View {
    
    let present: PresentModel
    let friend: DBUser
    let list: ListModel
    
    @State var isShowPresentCell = false
    @State private var isLoadingImage = false
    @GestureState private var isLongPressed = false
    @StateObject private var viewModel = PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: "", ownerId: "", whoReserved: ""))
    @Environment(\.colorScheme) var colorScheme
    @State private var isCellPressed = false
    
    // MARK: - init()
    init(present: PresentModel, friend: DBUser, list: ListModel) {
        self.present = present
        self.friend = friend
        self.list = list
    }
    
    var body: some View {
        
        
        Button {
            isCellPressed.toggle()
        } label: {
            VStack {
                Spacer()
                
                HStack {
                    Text(present.name)
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.bottom, -12)
                
                
                    
                HStack {
                    Text("")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.bottom, -8)
                
                HStack {
                    Text(present.presentDescription)
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                        .padding(.leading, 8)
                        .lineLimit(1)

                    
                    
                    Spacer()
                    
                    Circle()
                        .scaledToFill()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(present.isReserved ? .red : .green)
                        .padding(.trailing, 10)
                        .padding(.bottom, 5)
                }
                .padding(.bottom, 5)
                    
            }
            .frame(width: 160, height: 210)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray, lineWidth: 0.5)
                    .background(RoundedRectangle(cornerRadius: 7).fill(Color.white))
                    .shadow(color: .gray, radius: 3, x: 0, y: 5)
                    .frame(width: 160, height: 210)
                    .overlay(
                        VStack {
                            KFImage(viewModel.url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 140)
                                .clipped()
                            
                                .padding()
                            
                            Spacer()
                        }
                        
                    )
                    .frame(width: 140, height: 140)
            )
        }
        .sheet(isPresented: $isCellPressed) {
            PresentViewOtherList(friend: friend, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(), currentPresent: present, list: list)
        }
        
        
        .task {
            self.viewModel.url = try? await viewModel.getUrlPresentImage(presentId: present.id)
        }
        
        
        
        
        
    }
    
}
