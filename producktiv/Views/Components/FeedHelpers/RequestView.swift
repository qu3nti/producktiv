//
//  RequestView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/18/23.
//

import SwiftUI

struct RequestView: View {
    @EnvironmentObject var firebase: Firebase
    @Binding var selectedRequest: UserModel?
    @State var decisionClicked: Bool = false
    
    @State var typeOfNotification: String = "likecomment"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Spacer()
                Text("Friend Requests")
                    .foregroundColor(typeOfNotification == "request" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                    .font(.subheadline)
                    .fontWeight(typeOfNotification == "request" ? .bold : .semibold)
                    .onTapGesture {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            typeOfNotification = "request"
                        }
                    }
                Text("Notifications")
                    .foregroundColor(typeOfNotification == "likecomment" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))                    .font(.subheadline)
                    .fontWeight(typeOfNotification == "likecomment" ? .bold : .semibold)
                    .onTapGesture {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            typeOfNotification = "likecomment"
                        }
                    }
                Spacer()
            }

            ScrollView {
                if typeOfNotification == "request" {
                    ForEach(Array(firebase.friendRequests.enumerated()), id: \.offset) { idx, request in
                        Button {
                            selectedRequest = request
                        } label: {
                            RequestRow(person: request)
                        }
                        .sheet(item: $selectedRequest) { request in
                            ZStack {
                                VStack {
                                    Text("@\(request.userName)")
                                        .foregroundColor(Color(hex: 0x758eff) )
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    HStack {
                                        Button {
                                            firebase.declineFriend(user: request)
                                            dismiss()
                                        } label: {
                                            VStack {
                                                Image(systemName: "xmark")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 45, height: 45)
                                                    .padding()
                                                    .background(Color(hex: 0xffb258))
                                                    .clipShape(Circle())
                                                Text("Decline")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(hex: 0xffb258))
                                                    .opacity(0.45)
                                            }

                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            firebase.addFriend(user: request)
                                            dismiss()
                                        } label: {
                                            VStack {
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 45, height: 45)
                                                    .padding()
                                                    .background(Color(hex: 0x758eff))
                                                    .clipShape(Circle())
                                                Text("Accept")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(hex: 0x758eff))
                                                    .opacity(0.45)
                                            }
                                        }
                                    }
                                    .frame(width: 250)
                                    .presentationDetents([.fraction(0.27)])
                                }.padding()
                            }
                        }
                    }
                    .presentationDetents([.fraction(0.6)])
                }
                
                if typeOfNotification == "likecomment" {
                    ForEach(firebase.notifications) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
        }.padding()
    }
}
