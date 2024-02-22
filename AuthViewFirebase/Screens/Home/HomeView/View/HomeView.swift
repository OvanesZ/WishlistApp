//
//  FirstView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    
    @State private var isShowReservedPresents = false
    @State private var isShowReservedPresentsCard = false

    @State private var isShowingNewPresentView = false
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    
    private var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                
                // MARK: -- LazyVGrid
                
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
                
                
                VStack {
                    
                    Spacer()
                    
                    Button {
                        isShowingNewPresentView = true
                    } label: {
                        Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                            .overlay {
                                SkeletonClearView()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70, alignment: .center)
                            }
                    }
                }
                .font(.system(size: 70))
                .opacity(0.95)
                .padding(.leading, 250)
//                .padding(.top, 420)
                .padding(.bottom, 50)
                .sheet(isPresented: $isShowingNewPresentView) {
                    NewPresentView(viewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", ownerId: "")))
                }
                .sheet(isPresented: $isShowReservedPresentsCard) {
                    ReservedPresentsCardView()
                }
                .navigationTitle("Мои пожелания")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isShowReservedPresentsCard = true
                        }, label: {
                            Text("Выбранные подарки")
                        })
                    }
                    
                    
                }
            }
        }
    }
}
