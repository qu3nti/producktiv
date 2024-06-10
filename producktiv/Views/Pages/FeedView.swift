//
//  FeedView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI
import FirebaseFirestore


struct FeedView: View {
    @State var showNotifications = false
    @State var selectedRequest: UserModel? = nil
    
    @State var selectedProfile: UserModel? = nil
    @State var selectedProfileId: String? = nil
    @EnvironmentObject var firebase: Firebase
    var body: some View {
//        if firebase.feed.count > 0 {
            VStack {
                if selectedProfileId != nil {
                    ProfileViewer(profileId: $selectedProfileId)
                        .padding()
                }
                
                if selectedProfileId == nil {
                    HStack {
                        Image("duck")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Spacer()
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            showNotifications.toggle()
                            if firebase.userData.newNotifications {
                                firebase.suppressNewNotifications()
                            }
                           
                        } label: {
                            ZStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                firebase.friendRequests.count > 0 || firebase.userData.newNotifications ?
                                Circle()
                                    .foregroundColor(.pink)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 6, y: -7)
                                : nil
                            }
                        }
                        .sheet(isPresented: $showNotifications) {
                            RequestView(selectedRequest: $selectedRequest)

                        }
                    }
                    .padding(.horizontal)

                    ScrollView {
                        ForEach(firebase.feed) { post in
                            Post(post: post, selectedProfileId: $selectedProfileId)
                        }
                        Spacer()
                        Text("You can only see updates from the last 36 hours")
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .scrollIndicators(.hidden)
                    .refreshable {
                        let seconds = 0.5
                        firebase.feed = [PostModel]()
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            // Put your code which should be executed with a delay here
                            firebase.fetchFeed()
                        }
                       
                    }
                }
//            }
//            .onAppear {
//                firebase.fetchFeed()
//            }
        }
    }
}

