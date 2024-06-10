//
//  ToDoBar.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/30/23.
//

import SwiftUI

struct ToDoBar: View {
    @EnvironmentObject var firebase: Firebase
    var todo: ToDoModel
    @State var offset: Int = 0

    
    var body: some View {
        HStack {
            if offset == 40 {
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        firebase.deleteToDo(todo: todo)
                        offset = 0
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(hex: todo.color))
                        .frame(width: 25, height: 25)
                        .offset(x: 25)
                }

            }
            ZStack {
                RoundedRectangle(cornerRadius: 12.5, style: .continuous)
                    .fill(Color(hex: todo.color))
                    .frame(width: 350, height: 50)
                HStack {
                    Text("\(todo.name.lowercased())")
                        .font(.system(size: 18))
//                        .foregroundColor(Color(hex: 0x758eff))
                        .foregroundColor(todo.color == 0xBDB2FF || todo.color == 0xA0C4FF ? Color.white : Color(hex: 0x758eff))
                                         
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
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color(hex: 0x758eff))
                                .frame(width: 25, height: 25)
                          
                            if todo.completed {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .frame(width: 15, height: 15)
                            }

                            
                        }
                    }
                    .disabled(todo.completed)

                }

                .padding()
                
                .frame(width: 350, height: 60)
            }
            .offset(x: CGFloat(self.offset))
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            let horizontalAmount = value.translation.width
                            
                            if horizontalAmount < 0 {
                                print("left swipe")
                                // left
                                withAnimation {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    if offset == 40 {
                                        offset -= 40
                                    }
                                    
                                    
                                }
                                
                            }
                            else {
                                print("right swipe")
                                // right
                                withAnimation {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    if offset < 40 {
                                        offset += 40
                                    }
                                    
                                   
                                }
                            }
                        })
        }

    }
}

