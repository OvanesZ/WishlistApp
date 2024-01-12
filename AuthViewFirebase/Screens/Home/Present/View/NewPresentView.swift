//
//  NewPresentView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI

struct NewPresentView: View {
    
    
    // MARK: - properties
    
    @State private var presentName = ""
    @State private var presentUrlForMarket = ""
    @State private var presentDescription = ""
    @State private var isImageAlert = false
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false
    
    @ObservedObject var viewModel: PresentModelViewModel
    @Environment(\.dismiss) var dismiss
    
   
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .overlay {
                            Image(uiImage: viewModel.uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .opacity(50)
                        .frame(width: 350, height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .onTapGesture {
                            isImageAlert.toggle()
                        }
                        .confirmationDialog("Откуда взять фотку", isPresented: $isImageAlert) {
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
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.uiImage)
                }
                .sheet(isPresented: $showImagePickerCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: $viewModel.uiImage)
                }
                
                HStack {
                    Text("Название")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                        .padding(.top, 15)
                    Spacer()
                }
                
                TextField("Название подарка", text: $presentName)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                
                Divider()
                
                HStack {
                    Text("Описание")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                    Spacer()
                }
                
                TextField("Описание подарка", text: $presentDescription)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                
                Divider()
                
                HStack {
                    Text("Ссылка на подарок")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                    Spacer()
                }
                
                TextField("Ссылка на подарок", text: $presentUrlForMarket)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        let newPresent = PresentModel(name: presentName, urlText: presentUrlForMarket, presentFromUserID: "", presentDescription: presentDescription)
                        viewModel.setPresent(newPresent: newPresent)
                        dismiss()
                    }) {
                        Text("Создать")
                            .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.top, 20)
                }
            }
        }
        Spacer()
    }
}


