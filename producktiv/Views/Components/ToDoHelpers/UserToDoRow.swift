//
//  UserToDoRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/31/23.
//

import SwiftUI

struct UserToDoRow: View {
    var todo: ToDoModel
    var body: some View {
        HStack {
            Text("\(todo.name)")
                .foregroundColor(Color(hex: 0x758eff))
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()

            ZStack {
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(hex: todo.color))
                    .frame(width: 25, height: 25)
              
                if todo.completed {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(hex: todo.color))
                        .frame(width: 15, height: 15)
                }
            }
        }
        .frame(height: 55)
    }
}
