//
//  LikerRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/23/23.
//

import SwiftUI

struct LikerRow: View {
    var liker: LikeModel
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
                    Image(systemName: liker.likerImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                }

                Text("@\(liker.likerUserName)")
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.footnote)
                    .fontWeight(.semibold)
                Spacer()
                
                Button {
                    !firebase.friends.contains(where: {$0.id == liker.id}) && liker.id != firebase.userData.id ?
                        firebase.sendFriendRequest(user: firebase.fetchUserData(userId: liker.id))
                        : nil
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(firebase.friends.contains(where: {$0.id == liker.id}) ? Color(hex: 0xffb258) : Color(hex: 0x758eff))
                            .frame(width: 125, height: 35)
                            .cornerRadius(10)
                        HStack {
                            if firebase.friends.contains(where: {$0.id == liker.id}) {
                                Text("Friends")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            else if liker.id == firebase.userData.id {
                                Text("Hey, You")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "face.smiling.inverse")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            else if firebase.sentRequests.contains(where: {$0.id == liker.id}) {
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
//            .padding(.leading)
//            .padding(.trailing)
            .frame(height: 55)
//            Divider()
        }

    }
}
//
//struct UserFriendRow_Previews: PreviewProvider {
//    static var previews: some View {
//        UserFriendRow()
//    }
//}

