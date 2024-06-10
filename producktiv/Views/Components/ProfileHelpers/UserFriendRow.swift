//
//  UserFriendRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/17/23.
//

import SwiftUI

struct UserFriendRow: View {
    var friend: UserModel
    var friendIdx: Int
    @EnvironmentObject var firebase: Firebase
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
                        .background(Color(hex: 0x758eff))
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Image(systemName: friend.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                }

                Text("@\(friend.userName)")
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.footnote)
                    .fontWeight(.semibold)
                Spacer()
                
                Button {
                    !firebase.friends.contains(friend) && friend != firebase.userData ? firebase.sendFriendRequest(user: friend) : nil
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(firebase.friends.contains(friend) ? Color(hex: 0xffb258) : Color(hex: 0x758eff))
                            .frame(width: 125, height: 35)
                            .cornerRadius(5)
                        HStack {
                            if firebase.friends.contains(friend) {
                                Text("Friends")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            else if friend.id == firebase.userData.id {
                                Text("Hey, You")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "face.smiling.inverse")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            else if firebase.sentRequests.contains(friend) {
                                Text("Pending")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            else {
                                Text("Add Friend")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }

                            

                        }
                    }
                }
            }
            .frame(height: 55)
        }

    }
}
