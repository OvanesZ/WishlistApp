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
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        
        
        
        NavigationStack {
            ZStack {
                HStack {
                    Button(action: {
                        
                        isShowNewListView.toggle()
                        
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
                                    
                                    HStack {
                                        Text("12.06.1991")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                            .padding(.bottom, 10)
                                            .padding(.leading)
                                        
                                        Spacer()
                                    }
                                    
                                }
                                .frame(width: 170, height: 220)
                                .background(
                                    
                                    RoundedRectangle(cornerRadius: 28)
                                        .frame(width: 170, height: 220)
                                        .overlay(
                                            Image("logo_wishlist")
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
                                // TODO Переход к списку подарков
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
                CalendarView(currentMonth: $currentMonth)
                    .presentationDetents([.medium])
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




struct CalendarView: View {
    @Binding var currentMonth: Date
    
    private var days: [String] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let daysArray = range.map { String($0) }
        return daysArray
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(5)
                    .padding(2)
            }
        }
        .padding()
    }
}
