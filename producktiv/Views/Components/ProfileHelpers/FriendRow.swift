//
//  FriendRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/15/23.
//

import SwiftUI

struct FriendRow: View {
    var friend: UserModel
    var friendIdx: Int
    @EnvironmentObject var firebase: Firebase
    @State var friendsButtonClicked: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke( Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
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
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    friendsButtonClicked.toggle()
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: 0xffb258))
                            .frame(width: 130, height: 35)
                            .cornerRadius(5)
                        HStack {
                            Text("Friends")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .sheet(isPresented: $friendsButtonClicked) {
                    VStack {
                        Text("Remove @\(friend.userName) as a friend?")
                            .foregroundColor(Color(hex: 0x758eff) )
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack {
                            Button {
                                friendsButtonClicked.toggle()
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
                                    Text("Nevermind")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: 0xffb258))
                                        .opacity(0.45)
                                }

                            }
                            Spacer()
                            
                            Button {
                                firebase.removeFriend(user: friend)
                                friendsButtonClicked.toggle()
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
                                    Text("Unfriend")
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
            .frame(height: 55)
        }

    }
}

