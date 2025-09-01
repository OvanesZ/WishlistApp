//
//  UserListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.01.2025.
//

import SwiftUI

struct UserListView: View {
    
    let list: ListModel
    
    init(list: ListModel) {
        self.list = list
    }
    
    @State private var isShowReservedPresentsCard = false
    @State private var isShowPaymentViewController = false
    @State private var isDeletList = false
    

    @State private var isShowingNewPresentView = false
    @State private var isShowPayScreen = false
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @Environment(\.dismiss) var dismiss
    
    
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
                                    PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: list)
                                    
                                } label: {
                                    PresentCellView(present: present)
                                }
                                
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.isStopListener = false
                    viewModel.fetchOtherWishlist(list: list)
                }
                .onDisappear {
                    viewModel.isStopListener = true
                    viewModel.fetchOtherWishlist(list: list)
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
                        
                        VStack {
                            Image(systemName: "plus")
                                .foregroundStyle(Color("textColor"))
                                .shadow(color: .gray, radius: 2, y: 6)
                                .font(.title)
                                .bold()
                        }
                        .overlay {
                            SkeletonClearView()
                                .frame(width: 110, height: 110, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                        }
                        .frame(width: 110, height: 110)
                        .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color("fillColor"))
                            .frame(width: 110, height: 110)
                            .shadow(color: .gray, radius: 6, y: 6)
                        )
                        
                        
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
                    NewOtherPresentView(list: list, viewModel: HomeViewModel())
                }
                .sheet(isPresented: $isShowPaymentViewController) {
                    PaymentViewControllerRepresentable()
                        .presentationDetents([.medium, .large])
                }
                .navigationTitle(list.name)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isDeletList.toggle()
                        } label: {
                            Text("Удалить список")
                                .font(.callout)
                                .foregroundStyle(.red)
                        }
                        .confirmationDialog("Удалить список?", isPresented: $isDeletList, titleVisibility: .visible) {
                            Button(role: .destructive) {
                                viewModel.removingListImage(list: list)
                                viewModel.removingList(list: list)
                                viewModel.deletePresentImage()
                                dismiss()
                            } label: {
                                Text("Да")
                            }
                        }

                    }
                }
            }
        }
    }
}

//#Preview {
//    UserListView()
//}
