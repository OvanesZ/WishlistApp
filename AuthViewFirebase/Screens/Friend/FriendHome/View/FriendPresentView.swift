//
//  FriendPresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI

struct FriendPresentView: View {
    
    
    
    let currentPresent: PresentModel
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @ObservedObject var friendViewModel: FriendHomeViewModel
    let nameTextUrl: String = "[Ссылка на подарок]"
    
    init(currentPresent: PresentModel, presentModelViewModel: PresentModelViewModel, friendViewModel: FriendHomeViewModel) {
        self.currentPresent = currentPresent
        self.presentModelViewModel = presentModelViewModel
        self.friendViewModel = friendViewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .overlay {
                        Image(uiImage: presentModelViewModel.uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .opacity(50)
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                
                HStack {
                    Text("Описание")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                        .padding(.top, 25)
                    Spacer()
                }
                
                // https://fonts-online.ru/fonts/volja/download Скачать новые шрифты
                
                
                HStack {
                    Text(presentModelViewModel.present.presentDescription)
                        .frame(minHeight: 25, idealHeight: 25, maxHeight: 50)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .padding(.top, 5)
                        .font(.custom("SF-Pro-Display-Regular", fixedSize: 14))
                    
                    Spacer()
                }
                
                Divider()
                    .padding()
                
                HStack {
                    Text(.init(nameTextUrl+"(\(presentModelViewModel.present.urlText))"))
                        .underline()
                        .padding(.leading, 15)
                    Spacer()
                }
                
                Divider()
                    .padding()
                Spacer()
                
                
                // MARK: -- Статус подарка
                
                VStack {
                    HStack {
                        if presentModelViewModel.isHiddenReservButton {
                            Text("Подарок зарезервирован")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .opacity(15)
                                .padding(.leading, 15)
                            
                        } else {
                            Text("Подарок свободен")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
                                .opacity(15)
                                .padding(.leading, 15)
                        }
                        Spacer()
                    }
                    
                }
                
                Divider()
                    .padding()
                
                // MARK: -- Кнопка выбрать подарок
                
                if presentModelViewModel.isHiddenReservButton {
                    Spacer()
                        .padding(.bottom, 45)
                } else {
                    Button(action: {
                        presentModelViewModel.reservingPresentForUserID(currentPresent, friendViewModel.friend.userId)
                    }) {
                        Text("Выбрать подарок")
                            .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.bottom, 15)
                }
                
            }
        }
        .onAppear {
            presentModelViewModel.getPresentImage()
        }
        .navigationTitle(presentModelViewModel.present.name)
        
        
    }
    
    
}

