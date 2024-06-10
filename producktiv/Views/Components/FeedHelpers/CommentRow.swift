//
//  CommentRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/22/23.
//

import SwiftUI

struct CommentRow: View {
    @EnvironmentObject var firebase: Firebase
    var comment: CommentModel
    var post: PostModel
    @Binding var selectedProfileId: String?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
                        .background(Color(hex: 0x758eff) )
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Image(systemName: comment.authorImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                }
                .onTapGesture {
                    withAnimation {
                        selectedProfileId = comment.authorId
                    }
                }
                VStack(alignment: .leading) {
                    Text("@\(comment.authorUserName)")
                        .foregroundColor(Color(hex: 0x758eff) )
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .onTapGesture {
                            withAnimation {
                                selectedProfileId = comment.authorId
                            }
                        }
                    Text("\(Date(timeIntervalSince1970: TimeInterval(comment.timestamp.seconds)).timeAgoDisplay())")
                        .font(.caption)
                        .foregroundColor(Color(hex: 0x758eff))
                        .fontWeight(.semibold)
                        .opacity(0.5)
                }
                Spacer()
                
                if comment.authorId == firebase.userData.id {
                    Button {
                        firebase.deleteCommentOnPost(post: post, comment: comment)
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hex: 0xffb258))
                            .frame(width: 15, height: 15)
                    }

                }


            }
            .frame(width: 350)
            Text("\(comment.comment)")
                .font(.subheadline)
                .foregroundColor(Color(hex: 0x758eff) )
                .fontWeight(.semibold)
        }
        
    }
}

//struct CommentRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentRow()
//    }
//}
