//
//  Home.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var firebase: Firebase
    @State var isHomeClicked = false
    @State var page: String = "home"
    
    var body: some View {
        VStack {
            switch page {
                case "home":
                    HomeView(page: $page)
                case "profile":
                    ProfileView()
                        .adaptsToKeyboard()
                case "settings":
                    SettingsView()
                case "feed":
                    FeedView()
                        .adaptsToKeyboard()
                case "add/streak":
                    AddView(page: $page)
                        .adaptsToKeyboard()
                case "add/todo":
                    AddView(page: $page)
                        .adaptsToKeyboard()
                default:
                    HomeView(page: $page)
                        .adaptsToKeyboard()
            }
            Spacer()
            NavigationBar(page: $page, isHomeClicked: $isHomeClicked)
        }
        .onAppear {
            withAnimation {
                self.firebase.fetchUserData()
                self.firebase.fetchTaskData()
                self.firebase.fetchToDoData()
                self.firebase.fetchFriendData()
                self.firebase.fetchFriendRequests()
                self.firebase.fetchNotifications()
            }
        }
    }    
}
