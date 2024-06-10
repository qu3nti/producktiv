//
//  UserCurrentStreakBox.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/25/23.
//

import SwiftUI

struct UserCurrentStreakBox: View {
    @EnvironmentObject var firebase: Firebase
    var task: TaskModel
    
    var colorDictionary: [String : Color] = [
        "figure.run": Color(hex: 0x758eff),
        "figure.and.child.holdinghands": Color(hex: 0xffe675),
        "cross.circle.fill" : Color(hex: 0xffb258),
        "book.fill" : Color(hex: 0x77DD77),
        "fork.knife" : Color(hex: 0xFF6961)
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(colorDictionary[task.img]!)
                .frame(width: 300, height: 200)
            
            HStack(spacing: 5) {
                Image(systemName: "laurel.leading")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
                Image(systemName: "trophy.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
                Image(systemName: "laurel.trailing")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
            }
            
            VStack {
                Text("\(task.currentStreak) day\(task.currentStreak == 1 ? "": "s")")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Text("Current streak")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(task.longestStreak) day\(task.longestStreak == 1 ? "": "s")")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Text("Best streak")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .fontWeight(.semibold)
            }
            .padding(.vertical)
        }
    }
}

