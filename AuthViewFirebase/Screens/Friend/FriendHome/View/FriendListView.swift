//
//  FriendListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 24.08.2025.
//

import SwiftUI

struct FriendListView: View {
    
    let friend: DBUser
    @StateObject private var viewModel: FriendHomeViewModel
    

    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    init(friend: DBUser) {
            self.friend = friend
            self._viewModel = StateObject(
                wrappedValue: FriendHomeViewModel(friend: friend)
            )
        }
    
    
    
    
    var body: some View {
            ZStack {
                    LazyVGrid (
                        columns: columns,
                        alignment: .center,
                        spacing: 15,
                        pinnedViews: [.sectionFooters]
                    ) {
                        Section() {
                            //                            ForEach(viewModel.wishlist ?? [PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "", ownerId: "", whoReserved: "")]) { present in
                            //                                FriendPresentCellView(present: present, friend: viewModel.friend)
                            //                            }
                            
                            ForEach(viewModel.wishlist ?? []) { present in
                                NavigationLink {
                                    PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: nil)
                                } label: {
                                    PresentCellView(present: present)
                                }
                            }
                            
                        }
                    }
                .padding(.top, -8)
                
                
                Spacer()
            }
        
//        Text("Загрузка...")
//                    .onAppear {
//                        print("🟢 FriendListView: onAppear")
//                    }
        
        
        }
}

#Preview {
    ListView()
}
