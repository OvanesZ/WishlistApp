//
//  PresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import SwiftUI
import Kingfisher

struct PresentModalView: View {
    
    // MARK: - properties
    
    let currentPresent: PresentModel
    let nameTextUrl: String = "[Ссылка на подарок]"
    
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isLoadImage = false
    @State private var isEdit = false
    
    // MARK: - init()
    
    init(currentPresent: PresentModel, presentModelViewModel: PresentModelViewModel) {
        self.currentPresent = currentPresent
        self.presentModelViewModel = presentModelViewModel
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .overlay {
                        
                        KFImage(presentModelViewModel.url)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                    }
                    .opacity(50)
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                    .shadow(color: .gray, radius: 10)
                
                
                if isEdit {
                    VStack {
                        HStack {
                            Text("Название подарка")
                                .frame(maxWidth: .infinity, alignment: .leading)            
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
                                .padding(.leading, 15)
                                .padding(.top, 25)
                            
                        }
                   
                        
                        TextField("Название подарка", text: $presentModelViewModel.present.name)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                    }
                    
                }
                
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
                    if isEdit {
                        TextField("Описание подарка", text: $presentModelViewModel.present.presentDescription)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                    } else {
                        Text(presentModelViewModel.present.presentDescription)
//                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .multilineTextAlignment(.leading)
                            .padding(.leading, 15)
                            .padding(.trailing, 7)
                            .padding(.top, 5)
                            .font(.system(.callout, design: .rounded))
                            .font(.title)
                            .lineLimit(nil)
                        
//                        Spacer()
                    }
                }
                
                if !isEdit {
                    Divider()
                        .padding()
                    
                    Text(.init(nameTextUrl+"(\(presentModelViewModel.present.urlText))"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .underline()
                        .padding(.leading, 15)
                    
                    Divider()
                        .padding()
                    Spacer()
                    
                    // MARK: -- Статус подарка
                    
                    
                    VStack {
                        if presentModelViewModel.isHiddenReservButton {
                            Text("Подарок зарезервирован")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.red)
                                .opacity(15)
                                .padding(.leading, 15)
                            
                        } else {
                            Text("Подарок свободен")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
                                .opacity(15)
                                .padding(.leading, 15)
                        }
                    }
                    
                    Divider()
                        .padding()
                    
                } else {
                    Text("Ссылка на подарок")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                        .padding(.top, 25)
                    
                    TextField("Ссылка на подарок", text: $presentModelViewModel.present.urlText)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                }
              
                
                
                
                    
                
                
                
                
                // MARK: -- Кнопки удалить
                
                Button(action: {
                    presentModelViewModel.removingPresentFromWishlist(currentPresent.id)
                    presentModelViewModel.deletePresentImage()
                    dismiss()
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding(.bottom, 15)
                .padding(.top, isEdit ? 15 : 0)
            }
        }
        .task {
            try? await self.presentModelViewModel.url = presentModelViewModel.getUrlPresentImage(presentId: currentPresent.id)
        }
        .navigationTitle(isEdit ? "" : presentModelViewModel.present.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEdit.toggle()
                    }
                } label: {
                    Text("Редактировать")
                        .foregroundStyle(.blue)
                }

                
            }
        }
//        .redacted(reason: .placeholder)
    }
}



