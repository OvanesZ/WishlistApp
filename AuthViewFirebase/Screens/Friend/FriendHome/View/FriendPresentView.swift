//
//  FriendPresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI
import Kingfisher

struct FriendPresentView: View {
    
    
    
    let currentPresent: PresentModel
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @ObservedObject var friendViewModel: FriendHomeViewModel
    let nameTextUrl: String = "[Ссылка на подарок]"
    @State private var url: URL?
    
    init(currentPresent: PresentModel, presentModelViewModel: PresentModelViewModel, friendViewModel: FriendHomeViewModel) {
        self.currentPresent = currentPresent
        self.presentModelViewModel = presentModelViewModel
        self.friendViewModel = friendViewModel
    }
    
 
    
    var body: some View {
        ScrollView {
            VStack {
                Text(currentPresent.name)
                    .font(.title2.bold())
                    .padding()
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .overlay {
                        KFImage(url)
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
                                .foregroundColor(.red)
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
        } // scroll
        
        .onFirstAppear {
            
            StorageService.shared.downloadURLPresentImage(id: presentModelViewModel.present.id) { result in
                switch result {
                case .success(let url):
                    if let url = url {
                        self.url = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .navigationTitle(presentModelViewModel.present.name)
        
        
    }
    
    
}

