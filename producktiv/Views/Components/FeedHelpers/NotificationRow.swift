//
//  NotificationRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/27/23.
//

import SwiftUI

struct NotificationRow: View {
    var notification: NotificationModel
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
                    .background(Color(hex: 0x758eff) )
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                Image(systemName: notification.notifierImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
            }

            VStack(alignment: .leading) {
                Text("@\(notification.notifierUserName) \(notification.message)")
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text("\(Date(timeIntervalSince1970: TimeInterval(notification.timestamp.seconds)).timeAgoDisplay())")
                    .font(.caption)
                    .foregroundColor(Color(hex: 0x758eff))
                    .fontWeight(.semibold)
                    .opacity(0.5)
            }

            Spacer()

        }
        .frame(height: 55)
    }
}

