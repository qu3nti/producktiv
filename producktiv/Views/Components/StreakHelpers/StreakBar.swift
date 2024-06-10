//
//  StreakBar.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/24/23.
//

import SwiftUI

struct StreakBar: View {
    @EnvironmentObject var firebase: Firebase
    var task: TaskModel
    var taskIdx: Int
    
    @State var offset: Int = 0
    
    var colorDictionary: [String : Color] = [
        "figure.run": Color(hex: 0x758eff),
        "figure.and.child.holdinghands": Color(hex: 0xffe675),
        "cross.circle.fill" : Color(hex: 0xffb258),
        "book.fill" : Color(hex: 0x77DD77),
        "fork.knife" : Color(hex: 0xFF6961)
    ]
    
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            HStack {

                
                if offset == 40 {
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            firebase.deleteTask(task: task)
                            offset = 0
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 40, height: 40)
                            .offset(x: 30)
                    }

                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(colorDictionary[firebase.tasks[taskIdx].img]!)
                        .frame(width: 350, height: 60)
                    HStack {
                        Text("\(firebase.tasks[taskIdx].name)")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .background(Color(hex: 0x758eff))
                                .opacity(0.25)
                                .frame(width: 45, height: 45)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Image(systemName: firebase.tasks[taskIdx].img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.gray)
                                .opacity(0.25)
                                .frame(width: 30, height: 30)
                            VStack {
                                Text("\(firebase.tasks[taskIdx].currentStreak)")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                Text("day\(firebase.tasks[taskIdx].currentStreak == 1 ? "" : "s")")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 60)
                }
                .offset(x: CGFloat(self.offset))
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width
                                
                                if horizontalAmount < 0 {
                                    // left
                                    withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
//                                        if offset == 40 {
                                            offset -= 40

//                                        }
                                        print("left swipe, \(offset)")
                                    }
                                    
                                }
                                else {
                                    // right
                                    withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
//                                        if offset < 40 {
                                            offset += 40
//                                        }
                                        print("right swipe, \(offset)")
                                    }
                                }
                            })
                if offset == -40  {
                    !task.completedToday ?
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            firebase.incrementStreak(task: task)
                            offset = 0
                        }
                    } label: {
                        Image(task.completedToday ? "happy-duck" : "sad-duck")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
//                            .offset(x: -40)
                    }
                    .offset(x: -40)
                    :
                    nil
                    
                    task.completedToday ?
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)
                        .offset(x: -40)
                    : nil

                    
                }
            }

        }
    }
}

//struct StreakBar_Previews: PreviewProvider {
//    static var previews: some View {
//        StreakBar()
//    }
//}
