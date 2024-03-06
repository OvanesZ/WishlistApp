//
//  ReservedPresentsCardView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI

struct ReservedPresentsCardView: View {
    
    @StateObject private var viewModel: ReservedPresentsCardViewModel = ReservedPresentsCardViewModel()
//    private var columns: [GridItem] = [
//        GridItem(.fixed(150), spacing: 20)
//    ]
    var body: some View {
        
        
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if viewModel.presents.isEmpty {
                    Text("Вы еще не выбрали подарки друзьям.")
                        .font(.callout.italic())
                        .foregroundStyle(.blue)
                        .lineLimit(2)
                        .padding(.top, 25)
                } else {
                    ForEach(viewModel.presents) { present in
                        ReservedPresentsCardCell(present: present, viewModel: viewModel)
                            .padding(6)
                    }
                }
            }
            
//            LazyVGrid(
//                columns: columns,
//                alignment: .center, // позволяет нам выровнять содержимое сетки с помощью перечисления HorizontalAlignment для LazyVGrid и VerticalAlignment для LazyHGrid. Работает так же, как stack alignment
//                spacing: 15, // расстояние между каждой строкой внутри
//                pinnedViews: [.sectionFooters]
//            ) {
//                Section() {
//                    ForEach(viewModel.presents) { present in
//                        ReservedPresentsCardCell(present: present, viewModel: viewModel)
//                    }
//                }
//            }
            
            
            .task {
                try? await viewModel.getPresentsFromPresentsForFriend()
                try? await viewModel.getPresents()
            }
            .onDisappear {
                viewModel.presents = []
                viewModel.presentsForSell = []
            }
        }
        
        
    }
}

//#Preview {
//    ReservedPresentsCardView()
//}
