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
                        Text("Оплатить")
                    }
                }
                .font(.system(size: 70))
                .opacity(0.95)
                .padding(.leading, 250)
//                .padding(.top, 420)
                .padding(.bottom, 50)
                .sheet(isPresented: $isShowingNewPresentView) {
                    NewPresentView(viewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", ownerId: "", whoReserved: "")))
                }
                .sheet(isPresented: $isShowReservedPresentsCard) {
                    ReservedPresentsCardView()
                }
                .sheet(isPresented: $isShowPaymentViewController) {
                    PaymentViewControllerRepresentable()
                        .presentationDetents([.medium, .large])
                }
                .navigationTitle("Мои пожелания")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isShowReservedPresentsCard = true
                        }, label: {
                            HStack {
                                Image(systemName: "gift.fill")
                                
                                Text("друзьям")
                            }
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(4)
                            .padding([.leading, .trailing], 4)
                            .overlay {
                                Capsule()
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            }
                            
                        })
                    }
                    
                    
                }
            }
        }
    }
}
