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
    @State private var isImageAlert = false
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false

    
    // MARK: - init()
    
    init(currentPresent: PresentModel, presentModelViewModel: PresentModelViewModel) {
        self.currentPresent = currentPresent
        self.presentModelViewModel = presentModelViewModel
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                if isEdit {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .overlay {
                                Image(uiImage: presentModelViewModel.uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(alignment: .bottomTrailing) {
                                        Image(systemName: "pencil")
                                    }
                            }
                            .opacity(50)
//                            .frame(height: 350)
//                            .frame(maxWidth: .infinity, maxHeight: 350)
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .onTapGesture {
                                isImageAlert.toggle()
                            }
                            .confirmationDialog("Откуда взять фотографию?", isPresented: $isImageAlert) {
                                Button {
                                    showImagePickerLibrary.toggle()
                                    
                                } label: {
                                    Text("Галерея")
                                }
                                
                                Button {
                                    showImagePickerCamera.toggle()
                                    
                                } label: {
                                    Text("Камера")
                                }
                            }
                        Spacer()
                    }
                    .padding(.top, 25)
                    .sheet(isPresented: $showImagePickerLibrary) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $presentModelViewModel.uiImage)
                    }
                    .sheet(isPresented: $showImagePickerCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $presentModelViewModel.uiImage)
                    }
                } else {
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
                }
               
                
                
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
                
                Text("Описание")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 25)
                
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                            .padding(.trailing, 7)
                            .padding(.top, 5)
                            .font(.system(.callout, design: .rounded))
                            .font(.title)
                            .lineLimit(nil)
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
              
                
                
                
                    
                // MARK: -- Кнопки
                
                if isEdit {
                    Button {
                        // TODO
                    } label: {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.top, .bottom], 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.0859509632, green: 0.7268390059, blue: 0.4526766539, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(15)
                } else {
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
        }
        .task {
            try? await self.presentModelViewModel.url = presentModelViewModel.getUrlPresentImage(presentId: currentPresent.id)
        }
        .navigationTitle(isEdit ? "Внесите изменения" : presentModelViewModel.present.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.05)) {
                        isEdit.toggle()
                    }
                } label: {
                    Text(isEdit ? "Отменить" : "Редактировать")
                        .foregroundStyle(isEdit ? .red : .blue)
                }

                
            }
        }
//        .redacted(reason: .placeholder)
    }
}



