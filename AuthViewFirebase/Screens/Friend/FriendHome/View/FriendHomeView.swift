//
//  FriendHomeView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI

struct FriendHomeView: View {
    
    @ObservedObject var viewModel: FriendHomeViewModel
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @State private var isButtonPressed = false
    
    
    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    var body: some View {
        
        VStack {
            
            HeaderFriendCell(viewModel: viewModel)
            
            Divider()
                .padding([.leading, .trailing], 25)
            
            
            
            if viewModel.isFriendForFriendstArr {
                Text("Вы подписаны")
            } else {
                Button {
                    if viewModel.isFriendForRequestArr {
                        isButtonPressed.toggle()
                    } else {
                        viewModel.loadNewFriendInCollection(viewModel.friend)
                    }
                } label: {
                    Text(viewModel.isFriendForRequestArr ? "Ответить на запрос" : "Подписаться")
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Ваши действия", isPresented: $isButtonPressed) {
                    Button {
                        viewModel.answerToRequestAllow()
                    } label: {
                        Text("Разрешить")
                    }
                    
                    Button {
                        viewModel.answerToRequestReject()
                    } label: {
                        Text("Отклонить")
                    }
                }
            }
            
            
            
            
        }
            
            
            ScrollView {
                LazyVGrid (
                    columns: columns,
                    alignment: .center,
                    spacing: 15,
                    pinnedViews: [.sectionFooters]
                ) {
                    Section() {
                        ForEach(viewModel.wishlist) { present in
                            FriendPresentsMainView(present: present, friendHomeViewModel: viewModel)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.friend.displayName)
//            .onAppear(perform: viewModel.isFriendOrNo)
            .onAppear {
                presentModelViewModel.getPresentImage()
            }
        
        
    }
}
