//
//  ListCellView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2025.
//

import SwiftUI
import Kingfisher

struct ListCellView: View {
    
    let list: ListModel
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text(list.name)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                
                Spacer()
            }
            
            
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
//                    Image("list_image")
                    KFImage(viewModel.url)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .frame(width: 170, height: 220)
                        .scaledToFill()
                        .cornerRadius(28)
                        .colorMultiply(.gray)
                )
            
        )
        .task {
            try? await self.viewModel.url = viewModel.getUrlListImage(listId: list.id)
        }
        
        
    }
}

#Preview {
    ListCellView(list: ListModel(id: "1", name: ""))
}
