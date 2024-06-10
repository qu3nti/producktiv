//
//  ToDoRow.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/30/23.
//

import SwiftUI

struct ToDoRow: View {
    @EnvironmentObject var firebase: Firebase
    var todo: ToDoModel
    var body: some View {
        HStack {
            Text("\(todo.name)")
                .foregroundColor(Color(hex: 0x758eff))
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            
            Button {
                withAnimation {
                    firebase.completeToDo(todo: todo)
                }
            } label: {
                ZStack {
                    Image(systemName: "circle")
                        .resizable()
//                        .padding()
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
            .disabled(todo.completed)
        }
        .frame(height: 55)
    }
}

