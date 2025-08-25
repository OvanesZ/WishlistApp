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
    @Environment(\.dismiss) var dismiss
    

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
            ScrollView {
                LazyVGrid (
                    columns: columns,
                    alignment: .center,
                    spacing: 15,
                    pinnedViews: [.sectionFooters]
                ) {
                    Section() {
                        
                        ForEach(viewModel.wishlist ?? []) { present in
                            NavigationLink {
                                FriendPresentView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: viewModel)
//                                PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: nil)
                            } label: {
                                FriendPresentCellView(present: present, friend: self.friend)
//                                PresentCellView(present: present)
                            }
                        }
                        
                    }
                }
                .padding(.top, -8)
                
                
                Spacer()
            }
            .navigationTitle("Общий список")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    //                    Button("Назад") {
                    //                        dismiss()
                    //                    }
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .bold()
                            Text("Назад")
                        }
                    }
                    
                }
            }
            
            
        }
        }
}

#Preview {
    ListView()
}
