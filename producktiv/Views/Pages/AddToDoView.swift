//
//  AddToDoView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/30/23.
//

import SwiftUI
import FirebaseFirestore

struct AddToDoView: View {
    @EnvironmentObject var firebase: Firebase
    @Binding var page: String
    @State var name: String = ""
    @State var favorite: Bool = false
    @State var privacy: Bool = false
    @State var color: Int = 0
    
    @State var nameError: Bool = false
    @State var colorError: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            TextField("", text: $name, axis: .vertical)
                .placeholder(when: name.count == 0) {
                    Text("Enter todo title...").foregroundColor(Color(hex: 0x758eff))
                }
                .foregroundColor(Color(hex: 0x758eff))
                .font(.largeTitle)
                .fontWeight(.bold)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button {
                            self.endEditing()
                        } label: {
                            Text("Done")
                                .foregroundColor(Color(hex: 0x758eff))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                }


            ScrollView(.horizontal) {
                HStack {
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xFFADAD
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xFFADAD))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xFFADAD ? Color(hex: 0xFFADAD) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }

                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xFFD6A5
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xFFD6A5))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xFFD6A5 ? Color(hex: 0xFFD6A5) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xFDFFB6
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xFDFFB6))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xFDFFB6 ? Color(hex: 0xFDFFB6) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xCAFFBF
                        }
                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xCAFFBF))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xCAFFBF ? Color(hex: 0xCAFFBF) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0x9BF6FF
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0x9BF6FF))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0x9BF6FF ? Color(hex: 0x9BF6FF) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xA0C4FF
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xA0C4FF))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xA0C4FF ? Color(hex: 0xA0C4FF) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xBDB2FF
                        }

                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xBDB2FF))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xBDB2FF ? Color(hex: 0xBDB2FF) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            color = 0xFFC6FF
                        }
                    } label: {
                        VStack {
                            Circle()
                                .fill(Color(hex: 0xFFC6FF))
                                .frame(width: 50, height: 50)
                            
                            Ellipse()
                                .fill(color == 0xFFC6FF ? Color(hex: 0xFFC6FF) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onTapGesture {
                self.endEditing()
            }

            Group {
                HStack {
                    Text("Favorite:")
                        .foregroundColor(Color(hex: 0x758eff))
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            self.favorite = true
                        } label: {
                            Image(systemName: "checkmark")
                                .frame(width: self.favorite ? 50: 40, height: self.favorite ? 50: 40)
                                .background(self.favorite ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            self.favorite = false
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: !self.favorite ? 50: 40, height: !self.favorite ? 50: 40)
                                .background(!self.favorite ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                    }
                }
            }
            .onTapGesture {
                self.endEditing()
            }
            
            Group {
                HStack {
                    Text("Public:")
                        .foregroundColor(Color(hex: 0x758eff))
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            self.privacy = false
                        } label: {
                            Image(systemName: "checkmark")
                                .frame(width: !self.privacy ? 50: 40, height: !self.privacy ? 50: 40)
                                .background(!self.privacy ? Color(hex: 0x758eff)  : Color(hex: 0xffb258))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            self.privacy = true
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: self.privacy ? 50 : 40, height: self.privacy ? 50: 40)
                                .background(self.privacy ? Color(hex: 0x758eff)  : Color(hex: 0xffb258))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }

                    }
                }
            }
            .onTapGesture {
                self.endEditing()
            }
            
            Spacer()
            Spacer()
            Group {
                HStack {
                    VStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            name = ""
                            color = 0xFFFFFF
                            favorite = false
                            privacy = false
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color(hex: 0xffb258))
                                .clipShape(Circle())
                        }
                        Text("Reset")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: 0xffb258))
                            .opacity(0.45)
                        
                    }
                    Spacer()
                    VStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            if self.name.count == 0 || self.name.count > 20 {
                                nameError.toggle()
                            }
                            else if self.color == 0 {
                                colorError.toggle()
                            }
                            else {
                           
                                self.endEditing()
                                
                                firebase.addToDo(todo:
                                                    ToDoModel(
                                                        id: UUID().uuidString,
                                                        name: self.name,
                                                        color: self.color,
                                                        isPrivate: self.privacy,
                                                        isFavorite: self.favorite,
                                                        completed: false,
                                                        createdAt: Timestamp(date: Date()),
                                                        completedAt: Timestamp(date: Date(timeIntervalSince1970: 0))
                                                    )
                                )
                                page = "home"
                            }

                        } label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color(hex: 0x758eff))
                                .clipShape(Circle())
                        }
                        Text("Create")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: 0x758eff))
                            .opacity(0.45)
                    }
                }
                
            }
        }
        .padding()
        .onTapGesture {
            self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

