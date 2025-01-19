//
//  ListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.01.2025.
//

import SwiftUI

struct ListView: View {
    
    @State private var isShowReservedPresentsCard = false
    @State private var isShowPaymentViewController = false
    

    @State private var isShowingNewPresentView = false
    @State private var isShowPayScreen = false
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
                                    PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: nil)
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
                        if viewModel.wishlist.count >= 3 {
                            // TODO show screen for pay full version
                            guard let isPremium = viewModel.dbUser?.isPremium else { return }
                            if isPremium {
                                isShowingNewPresentView = true
                            } else {
                                isShowPayScreen = true
                            }
                        } else {
                            isShowingNewPresentView = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                            .overlay {
                                SkeletonClearView()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70, alignment: .center)
                            }
                    }
                }
                .confirmationDialog("Чтобы добавить больше пожеланий в список оформите полную версию приложения.", isPresented: $isShowPayScreen, titleVisibility: .visible) {
                    Button {
                        isShowPaymentViewController = true
                    } label: {
                        Text("Перейти к оплате (299 руб.)")
                    }
                }
                .font(.system(size: 70))
                .opacity(0.95)
                .padding(.leading, 250)
                .padding(.bottom, 50)
                .sheet(isPresented: $isShowingNewPresentView) {
                    NewPresentView(viewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", ownerId: "", whoReserved: "")))
                }
                .sheet(isPresented: $isShowPaymentViewController) {
                    PaymentViewControllerRepresentable()
                        .presentationDetents([.medium, .large])
                }
                .navigationTitle("Общий список")
            }
        }
    }
}

#Preview {
    ListView()
}
