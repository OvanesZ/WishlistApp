//
//  HomeViewNew.swift
//  Wishlist
//
//  Created by Ованес Захарян on 13.01.2025.
//

import SwiftUI


struct HomeViewNew: View {
    @State var items = [1]
    
    @State private var showingCalendar = false
    @State private var currentMonth: Date = Date()
    @State private var isShowReservedPresentsCard = false
    @State private var isShowNewListView = false
    @State private var isPresents = false
    @State private var isShowPayScreen = false
    @State private var isShowPaymentViewController = false
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        
        
        
        NavigationStack {
            ZStack {
                HStack {
                    Button(action: {
                        
                        //viewModel.lists
                        
                        if viewModel.lists.count >= 1 {
                            // TODO show screen for pay full version
                            guard let isPremium = viewModel.dbUser?.isPremium else { return }
                            if isPremium {
                                isShowNewListView.toggle()
                            } else {
                                isShowPayScreen = true
                            }
                        } else {
                            isShowNewListView.toggle()
                        }
                        
                    }, label: {
                        
                        VStack {
                            Image(systemName: "plus")
                                .foregroundStyle(Color("textColor"))
                                .shadow(color: .gray, radius: 2, y: 6)
                                .font(.title)
                                .bold()
                            
                            Text("Создать список")
                                .font(.caption)
                                .foregroundStyle(.black)
                                .padding(.bottom, -20)
                                .padding(.top, 3)
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color("fillColor"))
                                .frame(width: 110, height: 110)
                                .shadow(color: .gray, radius: 6, y: 6)
                        )
                    })
                    .padding()
                    .confirmationDialog("Чтобы добавить больше пожеланий в список оформите полную версию приложения.", isPresented: $isShowPayScreen, titleVisibility: .visible) {
                        Button {
                            isShowPaymentViewController = true
                        } label: {
                            Text("Перейти к оплате (299 руб.)")
                        }
                    }
                    .sheet(isPresented: $isShowPaymentViewController) {
                        PaymentViewControllerRepresentable()
                            .presentationDetents([.medium, .large])
                    }
                    
                    Button(action: {
                        showingCalendar.toggle()
                    }, label: {
                        
                        VStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(Color("textColor"))
                                .shadow(color: .gray, radius: 2, y: 6)
                                .font(.title)
                                .bold()
                            
                            Text("Календарь")
                                .font(.caption)
                                .foregroundStyle(.black)
                                .padding(.bottom, -20)
                                .padding(.top, 3)
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color("fillColor"))
                                .frame(width: 110, height: 110)
                                .shadow(color: .gray, radius: 6, y: 6)
                        )
                    })
                    .padding()
                    
                    Button(action: {
                        isShowReservedPresentsCard.toggle()
                    }, label: {
                        
                        VStack {
                            Image(systemName: "gift")
                                .foregroundStyle(Color("textColor"))
                                .shadow(color: .gray, radius: 2, y: 6)
                                .font(.title)
                                .bold()
                            
                            Text("Подарки друзьям")
                                .font(.caption)
                                .foregroundStyle(.black)
                                .padding(.bottom, -20)
                                .padding(.top, 3)
                            
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color("fillColor"))
                                .frame(width: 110, height: 110)
                                .shadow(color: .gray, radius: 6, y: 6)
                        )
                    })
                    .padding()
                }
                
                
            }
            .padding(.top, 110)
            .padding(.bottom)
            ////////// Прокручивание через LazyHGrid
            
            
         
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(250))], spacing: 10) {
                        
                        
                            NavigationLink {
                                ListView()
                            } label: {
                                VStack {
                                    Spacer()
                                    
                                    Text("Общий список")
                                        .font(.title3.bold())
                                        .foregroundStyle(.white)
                                        .padding(.bottom, 28)
                                        .padding(.trailing)
                                    
                                }
                                .frame(width: 170, height: 220)
                                .background(
                                    
                                    RoundedRectangle(cornerRadius: 28)
                                        .frame(width: 170, height: 220)
                                        .overlay(
                                            Image("presentList")
                                                .resizable()
                                                .frame(width: 170, height: 220)
                                                .scaledToFill()
                                                .cornerRadius(28)
                                                .colorMultiply(.gray)
                                        )
                                    
                                )
                            }

                        
                        ForEach(viewModel.lists) { list in
                            NavigationLink {
                                UserListView(list: list)
                            } label: {
                                ListCellView(list: list)
                            }
                        }
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.isStopListener = false
                    viewModel.fetchList()
                }
                .onDisappear {
                    viewModel.isStopListener = true
                    viewModel.fetchList()
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Главная")
                .padding(.bottom, 300)
                .background(
                    Image("bglogo_wishlist")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.4)
                        .aspectRatio(contentMode: .fill)
                        .padding()
                )
            }
            .sheet(isPresented: $showingCalendar, content: {
                CalendarView()
//                    .presentationDetents(viewModel.isShowFullCalendarView ? [.large] : [.medium])
                    .presentationDetents([.fraction(0.5)])
            })
            .sheet(isPresented: $isShowReservedPresentsCard) {
                ReservedPresentsCardView()
            }
            .sheet(isPresented: $isPresents, content: {
                HomeView()
            })
            .sheet(isPresented: $isShowNewListView, content: {
                NewListView(viewModel: viewModel)
                    .presentationDetents([.medium])
            })
            
            
            
        
        
        
        
        
    }
    
    
    
}

#Preview {
    HomeViewNew()
}



