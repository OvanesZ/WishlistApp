//
//  CalendarViewNew.swift
//  Wishlist
//
//  Created by Ованес Захарян on 24.01.2025.
//

import SwiftUI

struct CalendarViewNew: View {
    
    @State private var currentDate = Date()

    
    var body: some View {
        
        NavigationView {
    
            ZStack {
                
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
                        // TODO
                    }
                    
                } // LazyVGrid
            } // ZStack
        } // NavigationView
        
    }
    
    // MARK: -- private func
    
    private func getDaysInMonth() -> [Int] {
        let monthRange = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        return Array(monthRange)
    }
    
}

#Preview {
    CalendarViewNew()
}



struct DateCell: View {
    
    @ObservedObject var viewModel: HomeViewModel
    var day: Int
    var currentDate: Date
    let nowDate = Date()
    
    
    var body: some View {
        
        let currentDay = Calendar.current.component(.day, from: nowDate)
        let isBirthday = viewModel.myFriends.contains { friend in
            if let dateBirth = friend.dateBirth {
                let birthDay = Calendar.current.component(.day, from: dateBirth)
                let birthMonth = Calendar.current.component(.month, from: dateBirth)
                return birthDay == day && birthMonth == Calendar.current.component(.month, from: currentDate)
            }
            return false
        }
        
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
        
        
    }
}
