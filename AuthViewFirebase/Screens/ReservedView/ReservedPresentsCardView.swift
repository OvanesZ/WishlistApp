//
//  ReservedPresentsCardView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI

struct ReservedPresentsCardView: View {
    
    @StateObject private var viewModel: ReservedPresentsCardViewModel = ReservedPresentsCardViewModel()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                
                ForEach(viewModel.presents) { present in
                    ReservedPresentsCardCell(present: present, viewModel: viewModel)
                        .padding(6)
                }
                
                
                
            }
            .task {
                try? await viewModel.getDict()
                try? await viewModel.test()
                try? await viewModel.setFriends()
            }
        }
        
//        List {
//            ForEach(viewModel.presents) { present in
//                ReservedPresentsCardCell(present: present, viewModel: viewModel)
//            }
//        }
//        .listStyle(.plain)
//        .listRowSeparator(.hidden)
//        .listSectionSeparator(.hidden)
//        .task {
//            try? await viewModel.getDict()
//            try? await viewModel.test()
//            try? await viewModel.setFriends()
//        }
        
        
    }
}

//#Preview {
//    ReservedPresentsCardView()
//}
