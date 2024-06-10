//
//  RequestRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/17/23.
//

import SwiftUI

struct RequestRow: View {
    var person: UserModel
    @EnvironmentObject var firebase: Firebase
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color(hex: 0xffb258), style: StrokeStyle(lineWidth: 3))
                    .background(Color(hex: 0x758eff) )
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                Image(systemName: person.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
            }

            Text("@\(person.userName)")
                .foregroundColor(Color(hex: 0x758eff))
                .font(.footnote)
                .fontWeight(.semibold)
            Spacer()
            Text("\(person.firstName) \(person.lastName)")
                .foregroundColor(Color(hex: 0x758eff))
                .font(.footnote)
                .fontWeight(.semibold)
        }
        .frame(height: 55)
    }
}
