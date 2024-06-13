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
    @Environment(\.colorScheme) var colorScheme
    
   
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .overlay {
                            Button {
                                isImageAlert.toggle()
                            } label: {
                                Image(uiImage: viewModel.uiImage)
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
                            .frame(height: 350)
                            .frame(maxWidth: .infinity, maxHeight: 350)
                        }
                        .opacity(50)
                        .frame(height: 350)
                        .frame(maxWidth: .infinity, maxHeight: 350)

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
                
//                HStack {
//                    TextField("Название подарка", text: $presentName)
//                        .padding(.leading, 15)
//                        .padding(.trailing, 15)
//                        .padding(.bottom, 15)
//                        .textFieldStyle(.plain)
//                        .textInputAutocapitalization(.never)
//                    
//                    Button(role: .cancel) {
//                        
//                    } label: {
//                        Image(systemName: "pencil")
//                            .font(.title.bold())
//                            .foregroundStyle(.blue)
//                            .padding(.trailing, 8)
//                    }
//                }
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
                        let newPresent = PresentModel(name: presentName, urlText: presentUrlForMarket, presentFromUserID: "", presentDescription: presentDescription, ownerId: viewModel.currentUser?.uid ?? "", whoReserved: "")
                        viewModel.setPresent(newPresent: newPresent)
                        dismiss()
                    }) {
                        Text("Создать")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .foregroundStyle(colorScheme == .dark ? .black : .blue)
                            
                    }
                    .padding(.top, 20)
                    .buttonStyle(.borderedProminent)
                    .tint(Color("saveButton"))
                    .padding(15)
                }
            }
        }
        Spacer()
    }
}


