//
//  HomeSheet.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var firebase: Firebase
    @Binding var page: String
    @Binding var isHomeClicked: Bool
    
    @Namespace var namespace
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                withAnimation {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "add/streak"
                    self.isHomeClicked.toggle()
                }
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(self.page == "add/streak" || self.page == "add/todo" ? Color(hex: 0x758EFF) : Color(hex: 0xffb258))
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    if self.page == "add/streak" || self.page == "add/todo" {
                        Circle()
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .foregroundColor(Color.clear)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            Button {
                withAnimation {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "feed"
                    self.isHomeClicked.toggle()
                }
            } label: {
                VStack(spacing: 10) {
                    ZStack {
                        Image(systemName: "newspaper.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(self.page == "feed" ? Color(hex: 0x758EFF) : Color(hex: 0xffb258))
                            .frame(width: 25, height: 25)
                            .padding(.horizontal)
                        firebase.friendRequests.count > 0 || firebase.userData.newNotifications ?
                        Circle()
                            .foregroundColor(.pink)
                            .frame(width: 10, height: 10)
                            .offset(x: 20, y: -23)
                        : nil
                    }
                    if self.page == "feed" {
                        Circle()
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .foregroundColor(Color.clear)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            Button {
                withAnimation {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "home"
                    self.isHomeClicked.toggle()
                }
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(self.page == "home" ? Color(hex: 0x758EFF) : Color(hex: 0xffb258))
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    if self.page == "home" {
                        Circle()
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .foregroundColor(Color.clear)
                            .frame(width: 10, height: 10)
                    }
                }

            }
            Button {
                withAnimation {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "profile"
                    self.isHomeClicked.toggle()
                }

            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(self.page == "profile" ? Color(hex: 0x758EFF) : Color(hex: 0xffb258))
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    if self.page == "profile" {
                        Circle()
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .foregroundColor(Color.clear)
                            .frame(width: 10, height: 10)
                    }
                }

            }
            Button {
                withAnimation {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.page = "settings"
                    self.isHomeClicked.toggle()
                }
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(self.page == "settings" ? Color(hex: 0x758EFF) : Color(hex: 0xffb258))
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    if self.page == "settings" {
                        Circle()
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .foregroundColor(Color.clear)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(.top)
    }
}
