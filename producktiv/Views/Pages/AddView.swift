//
//  AddView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/30/23.
//

import SwiftUI

struct AddView: View {
    @Binding var page: String
//    @State var addChoice: String = "add/streak"
    var body: some View {
        VStack {
            Logo()
            
            HStack(spacing: 30) {
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        page = "add/streak"
                    }
                } label: {
                    VStack {
                        Text("Add Streak")
                            .foregroundColor(self.page == "add/streak" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            .font(.subheadline)
                            .fontWeight(.semibold)
//                        Divider()
//                            .overlay(self.addChoice == "streak" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                    }
                }
                
                Button {
                    withAnimation {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        page = "add/todo"
                    }
                } label: {
                    VStack {
                        Text("Add To-Do")
                            .foregroundColor(self.page == "add/todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                            .font(.subheadline)
                            .fontWeight(.semibold)
//                        Divider()
//                            .overlay(self.addChoice == "todo" ? Color(hex: 0x758eff) : Color(hex: 0xffb258))
                    }
                }
            }
            .padding(.horizontal)
//            Spacer()
            if page == "add/todo" {
                AddToDoView(page: $page)
                    .onTapGesture {
                        self.endEditing()
                    }
            }
            if page == "add/streak" {
                AddTaskView(page: $page)
                    .onTapGesture {
                        self.endEditing()
                    }
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}


