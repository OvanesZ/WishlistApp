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
        
        
        
//        ScrollView(.vertical, showsIndicators: false) {
            List {
                if viewModel.presents.isEmpty {
                    Text("Вы еще не выбрали подарки друзьям.")
                        .font(.callout.italic())
                        .foregroundStyle(.blue)
                        .lineLimit(2)
                        .padding(.top, 25)
                } else {
                    ForEach(viewModel.presents) { present in
                        ReservedPresentsCardCell(present: present, viewModel: viewModel)
                            .padding(-6)
                            .padding([.horizontal], -6)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color(.tertiarySystemFill))
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.unReservingPresentForUserID(present: present)
                                    Task {
                                        try await viewModel.deletePresentFriendPresentList(present: present)
                                        try await viewModel.getPresentsFromPresentsForFriend()
                                        try await viewModel.getPresents()
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    Task {
                                        try await viewModel.deletePresentFriendPresentList(present: present)
                                        try await viewModel.getPresentsFromPresentsForFriend()
                                        try await viewModel.getPresents()
                                    }
                                } label: {
                                    Label("Выполнено", systemImage: "checkmark.circle")
                                }
                                .tint(.green)
                            }
                    }
                }
            }
            .listStyle(.inset)
            
            
            .task {
                try? await viewModel.getPresentsFromPresentsForFriend()
                try? await viewModel.getPresents()
            }
            .onDisappear {
                viewModel.presents = []
                viewModel.presentsForSell = []
            }
//        }
        
        
    }
}

//#Preview {
//    ReservedPresentsCardView()
//}


