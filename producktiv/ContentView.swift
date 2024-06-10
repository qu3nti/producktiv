//
//  ContentView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebase: Firebase
    var body: some View {
        ZStack {
            Group {
                if firebase.user != nil {
                    Home()
                } else {
                    SignInView()
                }
            }.onAppear {
                firebase.listenToAuthState()
            }

        }
        .preferredColorScheme(.light)
    }
}
