//
//  ProfileViewer.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/26/23.
//

import SwiftUI

struct ProfileViewer: View {
    @Binding var profileId: String?
    
    @EnvironmentObject var firebase: Firebase
    @State var page: String = "streaks"
    
    @State var selectedStreak: TaskModel? = nil
    @State var selectedFriendId: String? = nil
    
    @State var showFriendSheet: Bool = false
    @State var showStreakSheet: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if selectedFriendId != nil {
                ProfileViewer(profileId: $selectedFriendId)

            }
            if selectedStreak != nil {
                TaskDetailSheet(task: $selectedStreak)
            }
            if profileId != nil && selectedFriendId == nil && selectedStreak == nil {
                VStack(spacing: 10) {
                    Button {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        withAnimation {
                            profileId = nil
                            firebase.viewingUser = UserModel(
                                id: "",
                                firstName: "",
                                lastName: "",
                                userName: "",
                                email: "",
                                icon: "",
                                newNotifications: false
                            )
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group {
                        ZStack {
                            Circle()
                                .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 5))
                                .background(Color(hex: 0x758eff))
                                .frame(width: 160, height: 160)
                                .clipShape(Circle())
                            Image(systemName: firebase.viewingUser.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                            
                        }

                        VStack(alignment: .leading) {
                            Text("\(firebase.viewingUser.firstName) \(firebase.viewingUser.lastName)")
                                .foregroundColor(Color(hex: 0x758eff))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("@\(firebase.viewingUser.userName)")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                    Group {
                        HStack {
                            Button {
                                withAnimation  {
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
//                                        .rotationEffect(self.page == "streaks" ? .degrees(360) : .degrees(0))
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
                                        .foregroundColor(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258) )
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
//                                        .rotationEffect(self.page == "friends" ? .degrees(360) : .degrees(0))
                                    Divider()
                                        .overlay(self.page == "friends" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                }

                            }
                        }
                        .frame(height: 35)
                    }
                
                    ScrollView {
                        
                        page == "streaks" ? Group {
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
                                            selectedFriendId = friend.id
                                        }
                                    }
                            }
                        }
                        :
                        nil
                    }
                    Spacer()
                }
                .onAppear {
                    firebase.fetchUserData(userId: profileId!)
                    firebase.fetchTaskData(userId: profileId!)
                    firebase.fetchFriendData(userId: profileId!)
                }
            }
        }
    }
}
