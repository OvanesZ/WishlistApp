//
//  ListPresentView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2025.
//

import SwiftUI

struct ListPresentView: View {
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    
    private var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    var body: some View {
        
        
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center, // позволяет нам выровнять содержимое сетки с помощью перечисления HorizontalAlignment для LazyVGrid и VerticalAlignment для LazyHGrid. Работает так же, как stack alignment
                spacing: 15, // расстояние между каждой строкой внутри
                pinnedViews: [.sectionFooters]
            ) {
                Section() {
                    ForEach(viewModel.wishlist) { present in
                        NavigationLink {
                            PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present))
                        } label: {
                            PresentCellView(present: present)
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            viewModel.isStopListener = false
            viewModel.fetchWishlist()
        }
        .onDisappear {
            viewModel.isStopListener = true
            viewModel.fetchWishlist()
        }
        .background(
            Image("bglogo_wishlist")
            .resizable()
            .scaledToFit()
            .opacity(0.4)
            .aspectRatio(contentMode: .fill)
            .padding()
        )
        
        
        
    }
}

#Preview {
    ListPresentView()
}
