//
//  SearchSheet.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/17/23.
//

import SwiftUI

struct SearchSheet: View {
    @EnvironmentObject var firebase: Firebase
    @State var query: String = ""
    @State var currentPerson: UserModel? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            if currentPerson == nil {
                Text("Find people")
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                TextField("", text: $query)
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.subheadline)
                    .submitLabel(.search)
                    .placeholder(when: query.count == 0) {
                        Text("Search for people")
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.subheadline)
                    }
                    .fontWeight(.semibold)
                    .onChange(of: query) { val in
                        if query != "" {
                            firebase.fetchUsers(query: query)
                        }
                        else {
                            firebase.searchedPeople = [UserModel]()
                        }
                    }
                ScrollView {
                    ForEach(Array(firebase.searchedPeople.enumerated()), id: \.offset) { idx, person in
                        UserFriendRow(friend: person, friendIdx: idx)
                            .onTapGesture {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                withAnimation {
                                    currentPerson = person
                                }
                            }
                    }
                }
            }
            
            if currentPerson != nil {
                ProfileSheet(profile: $currentPerson)
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
