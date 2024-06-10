//
//  Post.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/18/23.
//

import SwiftUI

struct Post: View {
    var post: PostModel
    @Binding var selectedProfileId: String?
    
    @State var commentClicked: Bool = false
    @State var comment: String = ""
    @State var showComments: Bool = false
    @State var showLikes: Bool = false
    @EnvironmentObject var firebase: Firebase
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center) {
                    ZStack {
                        Circle()
                            .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
                            .background(Color(hex: 0x758eff) )
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Image(systemName: post.authorImg)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                    }
                    .onTapGesture {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        withAnimation {
                            selectedProfileId = post.authorId
                        }
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("@\(post.authorUserName)")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: 0x758eff))
                            .fontWeight(.semibold)
                            .onTapGesture {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                withAnimation {
                                    selectedProfileId = post.authorId
                                }
                            }
                        Text("\(Date(timeIntervalSince1970: TimeInterval(post.timestamp.seconds)).timeAgoDisplay())")
                            .font(.caption)
                            .foregroundColor(Color(hex: 0x758eff))
                            .fontWeight(.semibold)
                            .opacity(0.5)
                    }

                Spacer()
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hex: 0xffb258))
                    .frame(width: 20, height: 20)

            }

            Text("\(post.content)")
                .font(.subheadline)
                .foregroundColor(Color(hex: 0x758eff) )
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.bottom)
            HStack {
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        if post.celebratorIds.contains(firebase.userData.id) {
                            firebase.unLikePost(post: post)
                        }
                        else {
                            firebase.likePost(post: post)
                        }
                    }
                } label: {
                    post.celebratorIds.contains(firebase.userData.id) ?
                    Image(systemName: "balloon.2.fill")
                        .font(.title3)
                        .foregroundColor(Color(hex: 0xffb258))
                        .fontWeight(.semibold)
                        .frame(width: 30, height: 30)
                    :
                    Image(systemName: "balloon.2")
                        .font(.title3)
                        .foregroundColor(Color(hex: 0x758eff))
                        .fontWeight(.semibold)
                        .frame(width: 30, height: 30)
                    
                }

                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    commentClicked.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                        .font(.title3)
                        .foregroundColor(Color(hex: 0x758eff) )
                        .fontWeight(.semibold)
                        .frame(width: 30, height: 30)
                }
                .sheet(isPresented: $commentClicked) {
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("Add comment to @\(post.authorUserName)'s post")
                                .foregroundColor(Color(hex: 0x758eff))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("", text: $comment)
                                .submitLabel(.send)
                                .foregroundColor(Color(hex: 0x758eff))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .placeholder(when: comment.count == 0) {
                                    Text("Add comment")
                                        .foregroundColor(Color(hex: 0x758eff))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .onSubmit {
                                    firebase.commentOnPost(post: post, comment: comment)
                                    comment = ""
                                    commentClicked.toggle()
                                }
                            Spacer()
                        }
                        .padding()

                    }
                    .presentationDetents([.fraction(0.25)])
                }



                Spacer()
                
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    firebase.viewingLikes = [LikeModel]()
                    firebase.fetchLikesOnPost(post: post)
                    showLikes.toggle()
                } label: {
                    Text("\(post.celebrateCount) cheers")
                        .font(.caption)
                        .foregroundColor(Color(hex: 0xffb258))
                        .fontWeight(.semibold)
                }
                .sheet(isPresented: $showLikes) {
                    VStack {
                        Text("Cheers on @\(post.authorUserName)'s post")
                            .foregroundColor(Color(hex: 0x758eff) )
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ScrollView {
                            ForEach(firebase.viewingLikes) { liker in
                                LikerRow(liker: liker)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedProfileId = liker.id
                                        }
                                    }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .presentationDetents([.fraction(0.995)])
                }

                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    firebase.viewingComments = [CommentModel]()
                    firebase.fetchCommentsOnPost(post: post)
                    showComments.toggle()
                } label: {
                    Text("\(post.commentCount) comments")
                        .font(.caption)
                        .foregroundColor(Color(hex: 0xffb258))
                        .fontWeight(.semibold)
                }
                .sheet(isPresented: $showComments) {
                    VStack(alignment: .leading) {
                        Text("Comments on @\(post.authorUserName)'s post")
                            .foregroundColor(Color(hex: 0x758eff) )
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ScrollView {
                            ForEach(firebase.viewingComments) { comment in
                                CommentRow(comment: comment, post: post, selectedProfileId: $selectedProfileId)
                            }
                        }
                        Spacer()
                        TextField("Add comment", text: $comment)
                            .submitLabel(.send)
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .placeholder(when: comment.count == 0) {
                                Text("Add comment")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                            }
                            .onSubmit {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                firebase.commentOnPost(post: post, comment: comment)
                                firebase.fetchCommentsOnPost(post: post)
                                comment = ""
                            }
                        
                    }
                    .padding()
                    .background(Color(hex: 0xFAF9F6))
                    .presentationDetents([.fraction(0.995)])

                }

                
            }
            .frame(height: 40)
        }
        .padding()
        .background(Color(hex: 0xF5F5F4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.leading)
        .padding(.trailing)
    }
}
