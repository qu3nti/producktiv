//
//  producktivApp.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct producktivApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var firebase = Firebase()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebase)
        }
    }
}
