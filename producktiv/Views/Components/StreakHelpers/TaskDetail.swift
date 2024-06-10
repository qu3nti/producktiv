//
//  TaskDetail.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI
import Charts

struct TaskDetail: View {
    
    var task: TaskModel
    var taskIdx: Int
    @Binding var selectedIdx: Int?
    @State var currentDate: Date = Date()
    
    
    @EnvironmentObject var firebase: Firebase
    @State private var edit: Bool = false
    @State private var delete: Bool = false
    @State private var partyTapped: Bool = false
    @State var deleteClicked: Bool = false
    
    @State var newTitle: String = ""
    @State var newDescription: String = ""
    @State var nameError: Bool = false
    @State var descriptionError: Bool = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if firebase.tasks.indices.contains(taskIdx) {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            withAnimation {
                                selectedIdx = nil
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
                        Spacer()
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                edit.toggle()
                            }
                        } label: {
                            Image(systemName: edit ? "pencil.slash" : "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15)
                                .padding()
                                .background(edit ? .pink : Color(hex: 0x758eff))
                                .clipShape(Circle())
                        }
                        if edit {
                            Button {
                                withAnimation {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    if self.newTitle.count == 0 || self.newTitle.count > 20 {
                                        nameError.toggle()
                                    }
                                    else if self.newDescription.count == 0 {
                                        descriptionError.toggle()
                                    }
                                    else {
                                        firebase.editStreak(task: task, newTitle: self.newTitle, newDescription: self.newDescription)
                                        edit.toggle()
                                    }
                                }

                            } label: {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: 15, height: 15)
                                    .padding()
                                    .background(.green)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    Group {
                        VStack(alignment: .center, spacing: 5) {
                            edit ? TextField("", text: $newTitle, axis: .vertical)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .placeholder(when: newTitle.count == 0) {
                                        Text("\(task.name)")
                                            .foregroundColor(Color(hex: 0x758eff))
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                    }
                            : nil
                            !edit ? Text("\(task.name)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: 0x758eff))
    //                                    .transition(.slide)

                            : nil
                            
                            !edit ? Text("\(task.description)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: 0x758eff))
                            : nil
                        
                            edit ? TextField("", text: $newDescription, axis: .vertical)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .placeholder(when: newDescription.count == 0) {
                                        Text("\(task.description)")
                                            .foregroundColor(Color(hex: 0x758eff))
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                    }
                            : nil
                        }
                        
                        CurrentStreakBox(taskIdx: taskIdx)
//                        HStack(spacing: 20) {
//                            Button {
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                impactMed.impactOccurred()
//                                firebase.decrementStreak(task: task)
//                            } label: {
//                                Image(systemName: "arrow.triangle.2.circlepath")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .foregroundColor(.white)
//
//                                    .frame(width: 25, height: 25)
//                                    .padding()
//                                    .background(Color(hex: 0xFF6961))
//                                    .opacity(!task.completedToday ? 0.5 : 1)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                            .disabled(!task.completedToday)
//
//                            Image(task.completedToday ? "happy-duck" : "sad-duck")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 90, height: 90)
//
//                            Button {
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                impactMed.impactOccurred()
//                                partyTapped.toggle()
//                                firebase.incrementStreak(task: task)
//                            } label: {
//                                Image(systemName: "balloon.2.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .foregroundColor(.white)
//
//                                    .frame(width: 25, height: 25)
//                                    .padding()
//                                    .background(Color(hex: 0x77DD77))
//                                    .opacity(task.completedToday ? 0.5 : 1)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                            .disabled(task.completedToday)
//                        }
                    }
                    
                    Spacer()
                    CalendarView(taskIdx: taskIdx, currentDate: $currentDate)
                }
                .alert("Your streak name must be shorter, but not nothing.", isPresented: $nameError) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Please describe your streak.", isPresented: $descriptionError) {
                    Button("OK", role: .cancel) { }
                }
            }
            .scrollIndicators(.hidden)
            .onTapGesture {
                self.endEditing()
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}


