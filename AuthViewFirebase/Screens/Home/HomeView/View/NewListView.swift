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
    @State private var testImage: UIImage = UIImage(named: "list_image")!
    
    
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
                        .textInputAutocapitalization(.never)
                    
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
                                Image(uiImage: testImage)
                                    .resizable()
                                    .frame(width: 75, height: 100)
                                    .scaledToFill()
                                    .cornerRadius(12)
                                    .colorMultiply(.gray)
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
            ImagePicker(sourceType: .photoLibrary, selectedImage: $testImage)
        }
        .sheet(isPresented: $showImagePickerCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $testImage)
        }
        
        
        
    }
}

#Preview {
    NewListView()
}
