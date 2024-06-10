//
//  StreakRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/15/23.
//

import SwiftUI

struct StreakRow: View {
//    var task: TaskModel
    @EnvironmentObject var firebase: Firebase
    var task: TaskModel
    var taskIdx: Int
    
    var colorDictionary: [String : Color] = [
        "figure.run": Color(hex: 0x758eff),
        "figure.and.child.holdinghands": Color(hex: 0xffe675),
        "cross.circle.fill" : Color(hex: 0xffb258),
        "book.fill" : Color(hex: 0x77DD77),
        "fork.knife" : Color(hex: 0xFF6961)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(task.name)")
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(colorDictionary[task.img]!)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Image(systemName: task.img)
                        .opacity(0.25)
                        .foregroundColor(.gray)
                        .font(.title2)
                    VStack {
                        Text("\(task.currentStreak)")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Text("day\(task.currentStreak == 1 ? "" : "s")")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                }
                

                
            }
            .frame(height: 55)
        }
    }
}
