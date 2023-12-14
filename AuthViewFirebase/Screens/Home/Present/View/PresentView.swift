//
//  PresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import SwiftUI
import Kingfisher

struct PresentModalView: View {
    
    let currentPresent: PresentModel
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @State private var isLoadImage = false
    let nameTextUrl: String = "[Ссылка на подарок]"
    
    init(currentPresent: PresentModel, presentModelViewModel: PresentModelViewModel) {
        self.currentPresent = currentPresent
        self.presentModelViewModel = presentModelViewModel
    }
    
    var body: some View {
        
        NavigationStack {
            
            HStack {
                Spacer()
                Text(presentModelViewModel.present.name)
                    .padding(.top, 40)
                    .font(.title2.bold())
                Spacer()
            }
            
            VStack {
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .overlay {
//                        Image(uiImage: presentModelViewModel.uiImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//
//                        if isLoadImage {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
//                                .scaleEffect(2)
//                        }
                        
//                        AsyncImage(url: urlImage) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 350, height: 350)
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 80, height: 80)
                        
                        KFImage(presentModelViewModel.url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        if isLoadImage {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(2)
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
                            Text("Подарит")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
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
                
                // MARK: -- Кнопки удалить
                
                Button(action: {
                    presentModelViewModel.removingPresentFromWishlist(currentPresent.id)
                    presentModelViewModel.deletePresentImage()
                }) {
                    Image(systemName: "trash")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                .padding(.bottom, 15)
            }
        }
//        .onFirstAppear {
//            isLoadImage = true
//            
//            StorageService.shared.downloadPresentImage(id: presentModelViewModel.present.id) { result in
//                switch result {
//                case .success(let data):
//                    isLoadImage = false
//                    if let img = UIImage(data: data) {
//                        presentModelViewModel.uiImage = img
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        .onFirstAppear {
            isLoadImage = true
            
            StorageService.shared.downloadURLPresentImage(id: presentModelViewModel.present.id) { result in
                switch result {
                case .success(let url):
                    isLoadImage = false
                    if let url = url {
                        self.presentModelViewModel.url = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        
    }
}



