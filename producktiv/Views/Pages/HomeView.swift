//
//  HomeView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct HomeView: View {
    @State var producktivChoice: String = "streak"
    @Binding var page: String
    @State var currentTask: TaskModel? = nil
    @State var currentIdx: Int = 0
    
    @State var selectedIdx: Int?
    
    @EnvironmentObject var firebase: Firebase

    
    var body: some View {
        VStack(alignment: .center) {
            Logo()
            HStack(spacing: 50) {
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        producktivChoice = "streak"
                    }
                } label: {
                    VStack {
                        Text("Streaks")
                            .foregroundColor(self.producktivChoice == "streak" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            .font(.subheadline)
                            .fontWeight(.semibold)
//                        Divider()
//                            .overlay(self.producktivChoice == "streak" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                    }
                }
                
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        producktivChoice = "todo"
                    }
                } label: {
                    VStack {
                        Text("To-Dos")
                            .foregroundColor(self.producktivChoice == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            .font(.subheadline)
                            .fontWeight(.semibold)
//                        Divider()
//                            .overlay(self.producktivChoice == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                    }
                }
            }
            
            if producktivChoice == "streak" {
                if firebase.tasks.count == 0 {
                    Spacer()
                    HStack {
                        Text("Go to ")
                            .foregroundColor(Color(hex: 0x758EFF))
                            .fontWeight(.bold)
                            .font(.headline)
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "add/streak"
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0xffb258))
                                .clipShape(Circle())
                        }
                        Text(" to add a new streak!")
                            .foregroundColor(Color(hex: 0x758EFF))
                            .fontWeight(.bold)
                            .font(.headline)
                    }

                    Spacer()
                }
                else {
                    if selectedIdx == nil {
                        ScrollView {
                            ForEach(Array(firebase.tasks.enumerated()), id: \.offset) { idx, task in
                                StreakBar(task: firebase.tasks[idx], taskIdx: idx)
                                    .onTapGesture {
                                        withAnimation {
                                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                            impactMed.impactOccurred()
                                            selectedIdx = idx
                                        }
                                    }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    if selectedIdx != nil {
                        TaskDetail(task: firebase.tasks[selectedIdx!], taskIdx: selectedIdx!, selectedIdx: $selectedIdx)
                    }
                }

            }
            
            if producktivChoice == "todo" {
                if firebase.todos.count == 0 {
                    Spacer()
                    HStack {
                        Text("Go to ")
                            .foregroundColor(Color(hex: 0x758EFF))
                            .fontWeight(.bold)
                            .font(.headline)
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "add/todo"
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0xffb258))
                                .clipShape(Circle())
                        }
                        Text(" to add a new to-do!")
                            .foregroundColor(Color(hex: 0x758EFF))
                            .fontWeight(.bold)
                            .font(.headline)
                    }

                    Spacer()
                }
                else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(firebase.todos.enumerated()), id: \.offset) { idx, todo in
                                ToDoBar(todo: todo)
                            }
                        }

                    }
                }

            }
            

        }
        .padding(.horizontal)
    }
}
