//
//  TaskDetailSheet.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/16/23.
//

import SwiftUI
import Charts

struct TaskDetailSheet: View {
    
    @Binding var task: TaskModel!
    @State var currentDate: Date = Date()

    @EnvironmentObject var firebase: Firebase
    @State private var edit: Bool = false
    @State private var delete: Bool = false
    @State private var partyTapped: Bool = false
    var body: some View {
        ScrollView {
            if task != nil {
                VStack(spacing: 10) {
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            task = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 15, height: 15)
                            .padding()
                            .background(Color(hex: 0x758eff))
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("\(task.name)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x758eff))
                        Text("\(task.description)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: 0x758eff))
                    }
                    Spacer()
                    UserCurrentStreakBox(task: task)
                    Spacer()
                    UserCalendarView(task: task, currentDate: $currentDate)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
