//
//  Task.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct Task: View {
    @EnvironmentObject var firebase: Firebase
    var task: TaskModel
    var description: Bool
    var taskIdx: Int

    
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .rotation(Angle(degrees: 90))
                        .stroke(firebase.tasks[taskIdx].isPrivate ? Color(hex: 0x758eff) : Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 8))
                        .background(firebase.tasks[taskIdx].isPrivate ? Color(hex: 0xffb258) : Color(hex: 0x758eff))
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                    
                    Image(systemName: firebase.tasks[taskIdx].img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(firebase.tasks[taskIdx].isPrivate ? Color(hex: 0xffe675) : Color.cyan)
                        .opacity(0.4)
                        .frame(width: 100, height: 100)
                        .padding()
                    VStack {
                        Text("\(firebase.tasks[taskIdx].currentStreak)")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("day\(firebase.tasks[taskIdx].currentStreak == 1 ? "" : "s")")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }

                    
                    firebase.tasks[taskIdx].isFavorite ?
                        Image("duck")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.yellow)
                            .frame(width: 35, height: 35)
                            .offset(x: 55, y: 55)
                            
                        :
                        Image(systemName: "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.yellow)
                            .frame(width: 35, height: 35)
                            .offset(x: 55, y: 55)
                }

                
                description ?
                Text("\(firebase.tasks[taskIdx].name.capitalized)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: 0x758eff))
                    .frame(alignment: .center)
                : nil
            }
        }
    }
}

