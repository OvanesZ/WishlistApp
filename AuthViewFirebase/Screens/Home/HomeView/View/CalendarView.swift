//
//  CalendarView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 23.01.2025.
//

import SwiftUI
import Kingfisher


struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var url: URL? = URL(string: "https://png.pngtree.com/thumb_back/fw800/background/20230610/pngtree-picture-of-a-blue-bird-on-a-black-background-image_2937385.jpg")
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    private var days = Calendar.current.range(of: .day, in: .month, for: Date())!
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("\(monthName(for: currentDate)) \(year(for: currentDate))")
                    .font(.title)
                    .padding()
                
                HStack {
                    Button {
                        // Переход на предыдущий месяц
                        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
                            currentDate = previousMonth
                        }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color("textColor"))
                                .font(.title.bold())
                                .padding()
                            
                            Spacer()
                        }
                    }
                    
                    Button {
                        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!) {
                            currentDate = nextMonth
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color("textColor"))
                                .font(.title.bold())
                                .padding()
                        }
                        
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

                            
                        }) {
                            let nowDate = Date()
                            let currentDay = Calendar.current.component(.day, from: nowDate)
                            
                            
                            
                            
                            let isBirthday = viewModel.myFriends.contains { friend in
                                if let dateBirth = friend.dateBirth {
                                    let birthDay = Calendar.current.component(.day, from: dateBirth)
                                    let birthMonth = Calendar.current.component(.month, from: dateBirth)
                                    return birthDay == day && birthMonth == Calendar.current.component(.month, from: currentDate)
                                }
                                return false
                            }
                            
                            
                            
                            if isBirthday {
                                if day == currentDay && monthName(for: currentDate) == monthName(for: nowDate) {
                                    Circle()
                                        .fill(Color.red.opacity(0.5))
                                        .overlay {
                                            Text("\(day)")
                                                .font(.system(size: 24))
                                                .frame(maxWidth: .infinity)
                                                .padding(.top, 6)
                                                .padding(.bottom, 6)
                                                .lineLimit(1)
                                                .tint(Color("textColor"))
                                                .overlay {
                                                    Circle()
                                                        .fill(Color.yellow)
                                                        .frame(width: 7, height: 7)
                                                        .offset(y: 18)
                                                }
                                        }
                                } else {
                                    KFImage(url)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                        .overlay {
                                            Text("\(day)")
                                                .font(.system(size: 12).bold())
                                                .padding(.top, 6)
                                                .padding(.bottom, 6)
                                                .lineLimit(1)
                                                .tint(Color.white)
                                                .overlay {
                                                    Circle()
                                                        .fill(Color.yellow)
                                                        .frame(width: 7, height: 7)
                                                        .offset(y: 22)
                                                }
                                        }
                                }
                            } else {
                                if day == currentDay && monthName(for: currentDate) == monthName(for: nowDate) {
                                    Circle()
                                        .fill(Color.red.opacity(0.5))
                                        .overlay {
                                            Text("\(day)")
                                                .font(.system(size: 24))
                                                .frame(maxWidth: .infinity)
                                                .padding(.top, 6)
                                                .padding(.bottom, 6)
                                                .lineLimit(1)
                                                .tint(Color("textColor"))
                                        }
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
                            }
                        }
                        .padding(2)
                        
                    }
                    
                }
            }
            .task {
                try? await viewModel.getMyFriendsID()
                try? await viewModel.getSubscriptions()
            }
        }
        
    }
    
    private func getDaysInMonth() -> [Int] {
        let monthRange = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        return Array(monthRange)
    }
    
//    private func monthName(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM"
//        return formatter.string(from: date)
//    }
    
    private func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL" // Используем LLLL для standalone формата
        return formatter.string(from: date).capitalized
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



//                            let friendIdsWithBirthdays = viewModel.myFriends.compactMap { friend -> String? in
//                                if let dateBirth = friend.dateBirth {
//                                    let birthDay = Calendar.current.component(.day, from: dateBirth)
//                                    let birthMonth = Calendar.current.component(.month, from: dateBirth)
//                                    if birthDay == day && birthMonth == Calendar.current.component(.month, from: currentDate) {
//
//                                        return friend.userId // Возвращаем id друга, если день рождения совпадает
//
//                                    }
//                                }
//                                return nil
//                            }
