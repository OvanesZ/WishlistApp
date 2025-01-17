//
//  ListCellView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2025.
//

import SwiftUI

struct ListCellView: View {
    
    let list: ListModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(list.name)
                .font(.title3.bold())
                .foregroundStyle(.white)
            
            HStack {
                Text("12.06.1991")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                    .padding(.leading)
                
                Spacer()
            }
            
        }
        .frame(width: 170, height: 220)
        .background(
            
            RoundedRectangle(cornerRadius: 28)
                .frame(width: 170, height: 220)
                .overlay(
                    Image("list_image")
                        .resizable()
                        .frame(width: 170, height: 220)
                        .scaledToFill()
                        .cornerRadius(28)
                        .colorMultiply(.gray)
                )
            
        )
        
        
    }
}

#Preview {
    ListCellView(list: ListModel(id: "1", name: ""))
}
