//
//  CurrentStreakBox.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/25/23.
//

import SwiftUI

struct CurrentStreakBox: View {
    @EnvironmentObject var firebase: Firebase
    var taskIdx: Int
    
    var colorDictionary: [String : Color] = [
        "figure.run": Color(hex: 0x758eff),
        "figure.and.child.holdinghands": Color(hex: 0xffe675),
        "cross.circle.fill" : Color(hex: 0xffb258),
        "book.fill" : Color(hex: 0x77DD77),
        "fork.knife" : Color(hex: 0xFF6961)
    ]
    
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorDictionary[firebase.tasks[taskIdx].img]!)
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
                    Text("\(firebase.tasks[taskIdx].currentStreak) day\(firebase.tasks[taskIdx].currentStreak == 1 ? "": "s")")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text("Current Streak")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(firebase.tasks[taskIdx].longestStreak) day\(firebase.tasks[taskIdx].longestStreak == 1 ? "": "s")")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text("Best Streak")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .fontWeight(.semibold)
                }
                .padding(.vertical)
            }
        }
    }
}

//struct CurrentStreakBox_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentStreakBox()
//    }
//}
