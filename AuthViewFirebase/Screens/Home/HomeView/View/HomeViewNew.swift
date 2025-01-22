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
                                        .padding(.bottom, 28)
                                        .padding(.trailing)
                                    
//                                    HStack {
//                                        Text("12.06.1991")
//                                            .font(.caption.bold())
//                                            .foregroundStyle(.white)
//                                            .padding(.bottom, 10)
//                                            .padding(.leading)
//                                        
//                                        Spacer()
//                                    }
                                    
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
                                // TODO Переход к списку подарков
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
//                CalendarView(currentMonth: $currentMonth)
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




//struct CalendarView: View {
//    @Binding var currentMonth: Date
//    
//    private var days: [String] {
//        let calendar = Calendar.current
//        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
//        let daysArray = range.map { String($0) }
//        return daysArray
//    }
//    
//    var body: some View {
//        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
//            ForEach(days, id: \.self) { day in
//                Text(day)
//                    .frame(width: 40, height: 40)
//                    .background(Color.gray.opacity(0.3))
//                    .cornerRadius(5)
//                    .padding(2)
//            }
//        }
//        .padding()
//    }
//}




//struct CalendarView: View {
//    @State private var currentDate = Date()
//    private var days = Calendar.current.range(of: .day, in: .month, for: Date())!
//    
//    var body: some View {
//        VStack {
//            Text("Календарь \(monthName(for: currentDate)) \(year(for: currentDate))")
//                .font(.title)
//                .padding()
//
//            let daysInWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
//                ForEach(daysInWeek, id: \.self) { day in
//                    Text(day)
//                        .fontWeight(.light)
//                }
//
//                ForEach(getDaysInMonth(), id: \.self) { day in
//                    Button(action: {
//                        // Ваш код при нажатии на дату
//                        print("Выбрана дата: \(day)")
//                    }) {
//                        Text("\(day)")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(10)
//                            .lineLimit(1)
//                    }
//                    .padding(4)
//                }
//            }
//        }
//    }
//
//    private func getDaysInMonth() -> [Int] {
//        let monthRange = Calendar.current.range(of: .day, in: .month, for: currentDate)!
//        return Array(monthRange)
//    }
//
//    private func monthName(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM"
//        return formatter.string(from: date)
//    }
//    
//    private func year(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY"
//        return formatter.string(from: date)
//    }
//}
//
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}

struct CalendarView: View {
    @State private var currentDate = Date()
    private var days = Calendar.current.range(of: .day, in: .month, for: Date())!
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Календарь \(monthName(for: currentDate)) \(year(for: currentDate))")
                    .font(.title)
                    .padding()
                
                HStack {
                    Button {
                        // Переход на предыдущий месяц
                        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
                            currentDate = previousMonth
                        }
                    } label: {
                        Image(systemName: "minus")
                    }
                    
                    Button {
                        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!) {
                                currentDate = nextMonth
                            }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                
                


                let daysInWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(daysInWeek, id: \.self) { day in
                        Text(day)
                            .fontWeight(.bold)
                    }

                    // Получаем первый день месяца и его день недели
                    let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
                    let startingWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
                    
                    // Корректируем день недели, чтобы неделя начиналась с понедельника
                    let adjustedStartingWeekday = (startingWeekday + 5) % 7 // Пн = 1, Вс = 7
                    
                    

                    // Добавляем пустые ячейки для дней до первого дня месяца
                    ForEach(0..<adjustedStartingWeekday, id: \.self) { _ in
                        Text("") // Пустая ячейка
                            .frame(maxWidth: .infinity)
                    }

                    ForEach(getDaysInMonth(), id: \.self) { day in
                        Button(action: {
                            // Ваш код при нажатии на дату
                            print("Выбрана дата: \(day)")
                            
                        }) {
                            var nowDate = Date()
                            let currentDay = Calendar.current.component(.day, from: nowDate)
                            if day == currentDay && monthName(for: currentDate) == monthName(for: nowDate) {
                                Text("\(day)")
                                    .font(.system(size: 24))
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 6)
                                    .padding(.bottom, 6)
                                    .background(Color("fillColor"))
                                    .cornerRadius(10)
                                    .lineLimit(1)
                                    .tint(Color("textColor"))
                            } else {
                                Text("\(day)")
                                    .font(.system(size: 12))
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 6)
                                    .padding(.bottom, 6)
                                    .background(Color("fillColor"))
                                    .cornerRadius(10)
                                    .lineLimit(1)
                                    .tint(Color("textColor"))
                            }
//                            Text("\(day)")
//                                .font(.system(size: 12))
//                                .frame(maxWidth: .infinity)
//                                .padding(.top, 6)
//                                .padding(.bottom, 6)
//                                .background(Color("fillColor"))
//                                .cornerRadius(10)
//                                .lineLimit(1)
//                                .tint(Color("textColor"))
                        }
                        .padding(2)
                    }
                }
            }
        }
        
    }

    private func getDaysInMonth() -> [Int] {
        let monthRange = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        return Array(monthRange)
    }
    
    private func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    private func year(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
