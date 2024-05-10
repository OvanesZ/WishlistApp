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
    @Environment(\.colorScheme) var colorScheme
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
                                Button {
                                    isImageAlert.toggle()
                                } label: {
                                    Image(uiImage: presentModelViewModel.uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .overlay(alignment: .center) {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .foregroundStyle(.blue)
                                                .opacity(0.3)
                                        }
                                }
                                .frame(width: 350, height: 350)
                            }
                            .opacity(50)
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
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
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.tertiarySystemFill)))
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
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
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.tertiarySystemFill)))
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
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
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.tertiarySystemFill)))
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .textInputAutocapitalization(.never)
                }
              
                
                
                
                    
                // MARK: -- Кнопки
                
                if isEdit {
                    Button {
                        // TODO
                        
                        let editPresent = PresentModel(id: presentModelViewModel.present.id, name: presentModelViewModel.present.name, urlText: presentModelViewModel.present.urlText, presentFromUserID: presentModelViewModel.present.presentFromUserID, isReserved: presentModelViewModel.present.isReserved, presentDescription: presentModelViewModel.present.presentDescription, ownerId: presentModelViewModel.present.ownerId, whoReserved: presentModelViewModel.present.whoReserved)
                        
                        presentModelViewModel.setPresent(newPresent: editPresent)
                        
                        dismiss()
                        
                        
                    } label: {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.top, .bottom], 8)
                            .foregroundStyle(colorScheme == .dark ? .black : .blue)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("saveButton"))
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
            
            try? await presentModelViewModel.getImageAsync()
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



