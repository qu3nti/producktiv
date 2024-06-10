//
//  SettingsView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var firebase: Firebase
    @State var reportBugClicked: Bool = false
    @State var giveSuggestionClicked: Bool = false
    @State var suggestion: String = ""
    @State var bug: String = ""
    var body: some View {
        VStack {
            Logo()
            Button {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                suggestion = ""
                giveSuggestionClicked.toggle()
//                firebase.giveSuggestion(suggestion: suggestion)

            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: 0x758eff))
                        .frame(width: 300, height: 40)
                        .cornerRadius(10)
                    Text(giveSuggestionClicked ? "Nevermind!" : "Suggest A Feature")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }

            }
            
            Button {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                bug = ""
                reportBugClicked.toggle()
//                firebase.reportBug(description: bug)

            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: 0x758eff))
                        .frame(width: 300, height: 40)
                        .cornerRadius(10)
                    Text(reportBugClicked ? "Nevermind!" : "Report A Bug")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }

            }
            giveSuggestionClicked ? VStack {
                TextField("", text: $suggestion, axis: .vertical)
                    .placeholder(when: suggestion.count == 0) {
                        Text("Suggest away, and be specific if possible!")
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.subheadline)
                    }
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.subheadline)
                
                
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    firebase.giveSuggestion(suggestion: suggestion)
                    giveSuggestionClicked.toggle()

                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: 0x758eff))
                            .frame(width: 200, height: 40)
                            .cornerRadius(10)
                        Text("Send suggestion")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }

                }
            } : nil
            
            reportBugClicked ? VStack {
                TextField("", text: $bug, axis: .vertical)
                    .placeholder(when: bug.count == 0) {
                        Text("Describe the bug, and be as specific as possible!")
                            .foregroundColor(Color(hex: 0x758eff))
                            .font(.subheadline)
                    }
                    .foregroundColor(Color(hex: 0x758eff))
                    .font(.subheadline)
                
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    firebase.reportBug(description: bug)
                    reportBugClicked.toggle()

                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: 0x758eff))
                            .frame(width: 200, height: 40)
                            .cornerRadius(10)
                        Text("Send report")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }

                }
                
            } : nil
            
            Spacer()
            Button {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                firebase.signOut()

            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: 0x758eff))
                        .frame(width: 300, height: 40)
                        .cornerRadius(10)
                    Text("Sign Out")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }

            }
        }
        .padding(.horizontal)
    }
}

