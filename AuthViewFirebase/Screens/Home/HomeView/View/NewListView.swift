//
//  NewListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2025.
//

import SwiftUI

struct NewListView: View {
    
    @State private var nameList: String = ""
    @State var dateList: Date = Date()
    @State private var isAvatarlertPresented = false
    @State private var showImagePickerLibrary = false
    @State private var showImagePickerCamera = false
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                VStack {
                    
                    Text("Создать список")
                        .font(.title3.bold())
                        .foregroundStyle(.gray)
                    
                    TextField("Название списка", text: $nameList)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                    
                    DatePicker(selection: $dateList, displayedComponents: [.date]) {
                        Text("Дата")
                    }
                    .datePickerStyle(.automatic)
                    .environment(\.locale, Locale.init(identifier: "ru_RU"))
                    .padding()
                    
                    
                    Button {
                        isAvatarlertPresented.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 75, height: 100)
                            .overlay(
                                Image(uiImage: viewModel.uiImage)
                                    .resizable()
                                    .frame(width: 75, height: 100)
                                    .scaledToFill()
                                    .cornerRadius(12)
                                    .colorMultiply(.gray)
                                    .overlay(alignment: .topTrailing) {
                                        ZStack {
                                            Circle()
                                                .fill()
                                                .frame(width: 20, height: 20)
                                                .foregroundStyle(Color("payButton"))
                                                .overlay(alignment: .center) {
                                                    Image(systemName: "camera")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 10, height: 10)
                                                        .foregroundStyle(.white)
                                                }
                                        }
                                        .offset(x: 10, y: -5)
                                    }
                            )
                    }
                    .confirmationDialog("Откуда взять фотографию?", isPresented: $isAvatarlertPresented) {
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
                    
                    Button(action: {
                        
                        let newList = ListModel(name: nameList, date: dateList)
                        viewModel.setList(newList: newList)
                        dismiss()
                    }) {
                        Text("Создать")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .foregroundStyle(.black)
                        
                    }
                    .padding(.top, 10)
                    .buttonStyle(.borderedProminent)
                    .tint(Color("payButton"))
                    .padding([.leading, .trailing],15)
                    .padding(.bottom, 10)
                    
                }
            }
            .padding(.top, 20)
        })
        .background(Color("fillColor"))
        .sheet(isPresented: $showImagePickerLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.uiImage)
        }
        .sheet(isPresented: $showImagePickerCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.uiImage)
        }
        
        
        
    }
}

//#Preview {
//    NewListView()
//}
