//
//  SearchBarView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        
        HStack {
            TextField("Поиск", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Отмена")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
//        .toolbar(isEditing ? .hidden : .visible, for: .navigationBar).animation(.linear(duration: 0.25))
//        .navigationBarHidden(isEditing).animation(.linear(duration: 0.25))
    }
}

//#Preview {
//    SearchBarView(text: .constant(""))
//}
