//
//  ProfileView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var firebase: Firebase
    @State var selectedStreak: TaskModel? = nil
    @State var selectedFriend: UserModel? = nil

    @State var page: String = "streaks"
    @State var showSearchSheet: Bool = false


    var body: some View {
        VStack {
            if selectedStreak == nil && selectedFriend == nil {
                Group {
                    ZStack {
                        Circle()
                            .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 5))
                            .background(Color(hex: 0x758eff))
                            .frame(width: 160, height: 160)
                            .clipShape(Circle())
                        Image(systemName: firebase.userData.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                    }
                    VStack(alignment: .leading) {
                        Text("\(firebase.userData.firstName) \(firebase.userData.lastName)")
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("@\(firebase.userData.userName)")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                
                Group {
                    HStack {
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "todo"
                            }
                        } label: {
                            VStack {
                                Text("To-Dos")
                                    .foregroundColor(self.page == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
//                                    .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                Divider()
                                    .overlay(self.page == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            }

                        }
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "streaks"
                            }
                        } label: {
                            VStack {
                                Text("Streaks")
                                    .foregroundColor(self.page == "streaks" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
//                                    .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                Divider()
                                    .overlay(self.page == "streaks" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            }

                        }
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "friends"
                            }
                        } label: {
                            VStack {
                                Text("Friends")
                                    .foregroundColor(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Divider()
                                    .overlay(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            }
                        }
                        Button {
                            withAnimation {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                self.page = "badges"
                            }
                        } label: {
                            VStack {
                                Text("Badges")
                                    .foregroundColor(self.page == "badges" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
//                                    .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                Divider()
                                    .overlay(self.page == "badges" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            }

                        }

                    }
                    .frame(height: 35)
                }
                
                ScrollView {
                    if page == "friends" {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            showSearchSheet.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Color(hex: 0x758eff))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .opacity(0.5)
                                    Text("search for people")
                                        .foregroundColor(Color(hex: 0x758eff))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .opacity(0.5)
                                }
                                .frame(width: 350, alignment: .leading)
                            }
                        }
                        .sheet(isPresented: $showSearchSheet) {
                            SearchSheet()
                                .presentationDetents([.fraction(1)])
                        }
                        .frame(height: 55)
                        ForEach(Array(firebase.friends.enumerated()), id: \.offset) { idx, friend in
                            FriendRow(friend: friend, friendIdx: idx)
                                .onTapGesture {
                                    withAnimation {
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
                                        selectedFriend = friend
                                    }
                                    
                                }
                        }
                    }

                    if page == "streaks" {
                        ForEach(Array(firebase.tasks.enumerated()), id: \.offset) { idx, task in
                            StreakRow(task: task, taskIdx: idx)
                                .onTapGesture {
                                    withAnimation {
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
                                        selectedStreak = task
                                    }
                                }
                        }
                    }
                    
                    if page == "todo" {
                        ForEach(Array(firebase.todos.enumerated()), id: \.offset) { idx, todo in
                            ToDoRow(todo: todo)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            if selectedStreak != nil {
                TaskDetailSheet(task: $selectedStreak)
            }
            
            if selectedFriend != nil {
                ProfileSheet(profile: $selectedFriend)
            }
        }
        .padding(.horizontal)
    }
}




