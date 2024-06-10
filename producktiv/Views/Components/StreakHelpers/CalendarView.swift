//
//  Calendar.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/25/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CalendarView: View {
    @EnvironmentObject var firebase: Firebase
    var taskIdx: Int
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var colorDictionary: [String : Color] = [
        "figure.run": Color(hex: 0x758eff),
        "figure.and.child.holdinghands": Color(hex: 0xffe675),
        "cross.circle.fill" : Color(hex: 0xffb258),
        "book.fill" : Color(hex: 0x77DD77),
        "fork.knife" : Color(hex: 0xFF6961)
    ]
    
    
    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            GroupBox {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(extractDate()[1])")
                                .font(.caption)
                                .foregroundColor(Color(hex: 0x758eff))
                                .fontWeight(.semibold)
                            Text("\(extractDate()[0])")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: 0x758eff))
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                currentMonth -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color(hex: 0x758eff))
                        }
                        
                        Button {
                            withAnimation {
                                currentMonth += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(Color(hex: 0x758eff))
                        }
                    }
                    .padding()
                    
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                            Text("\(day)")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(hex: 0x758eff))

                        }
                    }
                    
                    let columns = Array(repeating: GridItem(.flexible()), count: 7)
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(extractDate()) { day in
                            CardView(day: day)
                        }
                    }
                }
                .onChange(of: currentMonth) { month in
                    currentDate = getCurrentMonth()
                }
            }
            
        }

    }
    
    @ViewBuilder
    func CardView(day: DateValue) -> some View {
        VStack {
            if day.day != -1 {
                
                if firebase.tasks[taskIdx].daysCompleted.contains(Timestamp(date: day.date.noon)) {
                    VStack {
                        Text("\(day.day)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
                            .foregroundColor(colorDictionary[firebase.tasks[taskIdx].img]!)
                            .frame(maxWidth: .infinity)
                        Spacer()
                        Circle()
                            .fill(colorDictionary[firebase.tasks[taskIdx].img]!)
                            .frame(width: 8, height: 8)
                    }
                    

                }
                else {
                    Text("\(day.day)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: 0x758eff))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 40, alignment: .top)
        
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extractDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return []
        }
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
            
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0 ..< firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}
