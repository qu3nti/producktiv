//
//  AddTaskView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI
import FirebaseFirestore

struct AddTaskView: View {
    @EnvironmentObject var firebase: Firebase

    @Binding var page: String
    
    @State var descriptionError: Bool = false
    @State var nameError: Bool = false
    @State var iconError: Bool = false

    @State var name = ""
    @State var icon = ""
    @State var description = ""
    @State var units = ""
    @State var streak: Bool = false
    @State var favorite: Bool = false
    @State var privacy: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            TextField("", text: $name)
                .foregroundColor(Color(hex: 0x758eff))
                .font(.largeTitle)
                .fontWeight(.bold)
                .placeholder(when: name.count == 0) {
                    Text("Enter streak title...")
                        .foregroundColor(Color(hex: 0x758eff))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
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
            

            TextField("", text: $description, axis: .vertical)
                .placeholder(when: description.count == 0) {
                    Text("Enter description...")
                        .foregroundColor(Color(hex: 0x758eff))
                        .font(.subheadline)
                }
                .foregroundColor(Color(hex: 0x758eff))
                .font(.subheadline)
//                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        Spacer()
//                        Button {
//                            self.endEditing()
//                        } label: {
//                            Text("Done")
//                                .foregroundColor(Color(hex: 0x758eff))
//                                .font(.subheadline)
//                        }
//                    }
//                }

            Group {
                HStack {
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            icon = "fork.knife"
                        }
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "fork.knife")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0xFF6961))
                                .clipShape(Circle())
                            Ellipse()
                                .fill(icon == "fork.knife" ? Color(hex: 0xFF6961) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            icon = "cross.circle.fill"
                        }

                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "cross.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0xffb258))
                                .clipShape(Circle())
                            Ellipse()
                                .fill(icon == "cross.circle.fill" ? Color(hex: 0xffb258) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            icon = "figure.and.child.holdinghands"
                        }

                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "figure.and.child.holdinghands")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0xffe675))
                                .clipShape(Circle())
                            Ellipse()
                                .fill(icon == "figure.and.child.holdinghands" ? Color(hex: 0xffe675) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            icon = "book.fill"
                        }

                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "book.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0x77DD77))
                                .clipShape(Circle())
                            Ellipse()
                                .fill(icon == "book.fill" ? Color(hex: 0x77DD77) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                    Button {
                        withAnimation {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            icon = "figure.run"
                        }

                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "figure.run")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color(hex: 0x758eff))
                                .clipShape(Circle())
                            Ellipse()
                                .fill(icon == "figure.run" ? Color(hex: 0x758eff) : .clear)
                                .opacity(0.5)
                                .frame(width: 30, height: 10)
                        }
                    }
                }
//                Divider()
            }
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
            Group {
                HStack {
                    VStack {
                        Button {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            name = ""
                            icon = ""
                            description = ""
                            units = ""
                            streak = false
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
                            else if self.description.count == 0 {
                                descriptionError.toggle()
                            }
                            else if self.icon.count == 0 {
                                iconError.toggle()
                            }
                            else {
                                self.endEditing()
                                firebase.addTask(task:
                                                    TaskModel(
                                                        id: UUID().uuidString,
                                                        name: self.name,
                                                        description: self.description,
                                                        img: self.icon,
                                                        isFavorite: self.favorite,
                                                        isPrivate: self.privacy,
                                                        currentStreak: 0,
                                                        longestStreak: 0,
                                                        daysCompleted: [],
                                                        exactTimes: [],
                                                        lastUpdated: Timestamp(date: Date()),
                                                        completedToday: false
                                                    ))
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
        .onTapGesture {
            self.endEditing()
        }
        .padding(.horizontal)
        .alert("Your new streak name must be shorter, but not nothing.", isPresented: $nameError) {
            Button("OK", role: .cancel) { }
        }
        .alert("Please describe your new streak.", isPresented: $descriptionError) {
            Button("OK", role: .cancel) { }
        }
        .alert("Please choose an avatar for your new streak.", isPresented: $iconError) {
            Button("OK", role: .cancel) { }
        }
    }
    
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}

