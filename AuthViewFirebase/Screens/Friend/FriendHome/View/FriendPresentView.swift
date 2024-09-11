//
//  FriendPresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI
import Kingfisher

struct FriendPresentView: View {
    

    // MARK: - properties
    
    let currentPresent: PresentModel
    let nameTextUrl: String = "[Ссылка на подарок]"
    
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @ObservedObject var friendViewModel: FriendHomeViewModel
    
    @State private var isShowPayScreen = false
    @State private var isShowPaymentViewController = false
    @State private var url: URL?
    
 
    
    var body: some View {
        ScrollView {
            VStack {
                Text(currentPresent.name)
                    .font(.title2.bold())
                    .padding()
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .overlay {
                        
                        AsyncImage(
                            url: url,
                            transaction: Transaction(animation: .linear)
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "wifi.slash")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        
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
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .padding(.top, 5)
                        .font(.system(.callout, design: .rounded))
                        .font(.title)
                        .lineLimit(nil)
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
                    
                    if currentPresent.whoReserved == AuthService.shared.currentUser?.uid {
                        Button(action: {
                            
                            presentModelViewModel.unReservingPresentForUserID(currentPresent, friendViewModel.friend.userId)
                            
                            Task {
                                try await presentModelViewModel.deletePresentFriendPresentList(present: currentPresent)
                            }
                        }) {
                            Text("Отменить выбор")
                                .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                                .font(.headline)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        .padding(.bottom, 15)
                    }
                    
                    
                    
                    
                } else {
                    Button(action: {
                        
                        
                        guard let userIsPremium = friendViewModel.dbUser?.isPremium else { return }
                        
                        if userIsPremium {
                            
                            presentModelViewModel.reservingPresentForUserID(currentPresent, friendViewModel.friend.userId)
                            
                            Task {
                                try await presentModelViewModel.setFriendPresentList(present: currentPresent)
                            }
                            
                        } else {
                            
                            self.isShowPayScreen = true
                            print("not premium")
                            
                        }
                        
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
        .confirmationDialog("Чтобы забронировать подарок оформите полную версию приложения.", isPresented: $isShowPayScreen, titleVisibility: .visible) {
            Button {
                isShowPaymentViewController = true
            } label: {
                Text("Перейти к оплате (299 руб.)")
            }
        }
        .sheet(isPresented: $isShowPaymentViewController) {
            PaymentViewControllerRepresentable()
                .presentationDetents([.medium, .large])
        }
        .task {
            self.url = try? await friendViewModel.getUrlAsync(id: presentModelViewModel.present.id)
        }
        .navigationTitle(presentModelViewModel.present.name)
        
        
    }
    
    
}

