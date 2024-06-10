//
//  ProfileSheet.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/16/23.
//

import SwiftUI

struct ProfileSheet: View {
    @Binding var profile: UserModel?
    
    @EnvironmentObject var firebase: Firebase
    @State var page: String = "streaks"
    
    @State var selectedStreak: TaskModel? = nil
    @State var selectedFriend: UserModel? = nil
    
    @State var showFriendSheet: Bool = false
    @State var showStreakSheet: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if selectedFriend != nil {
                ProfileSheet(profile: $selectedFriend)

            }
            if selectedStreak != nil {
                TaskDetailSheet(task: $selectedStreak)
            }
            if profile != nil && selectedFriend == nil && selectedStreak == nil {
                ZStack(alignment: .topLeading) {
                    Button {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        withAnimation {
                            profile = nil
                            firebase.viewingTodos = [ToDoModel]()
                            firebase.viewingTasks = [TaskModel]()
                            firebase.viewingFriends = [UserModel]()
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
//                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 10) {

                        
                        Group {
                            ZStack {
                                Circle()
                                    .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 5))
                                    .background(Color(hex: 0x758eff))
                                    .frame(width: 160, height: 160)
                                    .clipShape(Circle())
                                Image(systemName: profile!.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 100)
                                
                            }

                            VStack(alignment: .leading) {
                                Text("\(profile!.firstName) \(profile!.lastName)")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("@\(profile!.userName)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        
                        Group {
                            HStack {
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    withAnimation  {
                                        self.page = "todo"
                                    }
                                } label: {
                                    VStack {
                                        Text("To-Dos")
                                            .foregroundColor(self.page == "todo" ?  Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
//                                            .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                        Divider()
                                            .overlay(self.page == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    }

                                }
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    withAnimation  {
                                        self.page = "streaks"
                                    }
                                } label: {
                                    VStack {
                                        Text("Streaks")
                                            .foregroundColor(self.page == "streaks" ?  Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
//                                            .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                        Divider()
                                            .overlay(self.page == "streaks" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    }

                                }
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    withAnimation {
                                        self.page = "friends"
                                    }
                                } label: {
                                    VStack {
                                        Text("Friends")
                                            .foregroundColor(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
//                                            .rotationEffect(self.page == "friends" ? .degrees(360) : .degrees(0))
                                        Divider()
                                            .overlay(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    }

                                }
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    withAnimation  {
                                        self.page = "badges"
                                    }
                                } label: {
                                    VStack {
                                        Text("Badges")
                                            .foregroundColor(self.page == "badges" ?  Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
//                                            .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
                                        Divider()
                                            .overlay(self.page == "badges" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                    }

                                }
                            }
                            .frame(height: 35)
                        }
                    
                        ScrollView {
                            page == "todo" ?
                            Group {
                                ForEach(Array(firebase.viewingTodos.enumerated()), id: \.offset) { idx, todo in
                                    UserToDoRow(todo: todo)
                                }
                            }
                            : nil
                            
                            page == "streaks" ?
                            Group {
                                ForEach(Array(firebase.viewingTasks.enumerated()), id: \.offset) { idx, task in
                                    StreakRow(task: task, taskIdx: idx)
                                        .onTapGesture {
                                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                            impactMed.impactOccurred()
                                            withAnimation {
                                                selectedStreak = task
                                            }
                                        }
                                }
                            }
                            :
                            nil
                            
                            page == "friends" ?
                            Group {
                                ForEach(Array(firebase.viewingFriends.enumerated()), id: \.offset) { idx, friend in
                                        UserFriendRow(friend: friend, friendIdx: idx)
                                        .onTapGesture {
                                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                            impactMed.impactOccurred()
                                            withAnimation {
                                                selectedFriend = friend
                                            }
                                        }
                                }
                            }
                            :
                            nil
                            
                        }
                        Spacer()
                    }
//                    .padding()
                    .onAppear {
                        firebase.fetchTaskData(userId: profile!.id)
                        firebase.fetchFriendData(userId: profile!.id)
                        firebase.fetchToDoData(userId: profile!.id)
                    }
                }
            }
        }
    }
}

