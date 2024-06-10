//
//  SignInView.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/16/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var firebase: Firebase

    @State var page: String = "signup"

    @State var iconError: Bool = false
    @State var firstNameError: Bool = false
    @State var lastNameError: Bool = false
    @State var userNameError: Bool = false
    @State var emailError: Bool = false
    @State var passwordLengthError: Bool = false
    @State var passwordVerifyError: Bool = false
    
    @State var signInUserNameError: Bool = false
    @State var signInPasswordError: Bool = false
    
    @State var icon: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordVerify: String = ""
    
    var body: some View {
        ScrollView {
            if page == "signup" {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        HStack {
                            Text("Sign up")
                                .foregroundColor(Color(hex:0x758EFF))
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            HStack(spacing: 2) {
                                Text("pro")
                                    .font(.title3)
                                    .foregroundColor(Color(hex: 0x758EFF))
                                    .fontWeight(.bold)
                                Image("duck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                Text(" tiv")
                                    .font(.title3)
                                    .foregroundColor(Color(hex: 0x758EFF))
                                    .fontWeight(.bold)
                            }
                        }
                        Divider()
                    }
                    Group {
                        Text("First Name")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("", text: $firstName)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: firstName.count == 0) {
                                Text("John")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Last Name")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("", text: $lastName)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: lastName.count == 0) {
                                Text("Deere")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Username")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("", text: $userName)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: userName.count == 0) {
                                Text("tractorlover1837")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Avatar")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ScrollView(.horizontal) {
                            HStack {
                                Button("") {
                                    icon = "microbe.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "microbe.fill",
                                    size: 25,
                                    active: icon == "microbe.fill"))
                                Button("") {
                                    icon = "hare.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "hare.fill",
                                    size: 25,
                                    active: icon == "hare.fill"))
                                Button("") {
                                    icon = "tortoise.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "tortoise.fill",
                                    size: 25,
                                    active: icon == "tortoise.fill"))
                                Button("") {
                                    icon = "lizard.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "lizard.fill",
                                    size: 25,
                                    active: icon == "lizard.fill"))
                                Button("") {
                                    icon = "ant.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "ant.fill",
                                    size: 25,
                                    active: icon == "ant.fill"))
                                Button("") {
                                    icon = "ladybug.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "ladybug.fill",
                                    size: 25,
                                    active: icon == "ladybug.fill"))
                                Button("") {
                                    icon = "fish.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "fish.fill",
                                    size: 25,
                                    active: icon == "fish.fill"))
                                Button("") {
                                    icon = "fossil.shell.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "fossil.shell.fill",
                                    size: 25,
                                    active: icon == "fossil.shell.fill"))
                                Button("") {
                                    icon = "carrot.fill"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "carrot.fill",
                                    size: 25,
                                    active: icon == "carrot.fill"))
                                Button("") {
                                    icon = "camera.macro"
                                }.buttonStyle(OmniButton(
                                    imageSystemName: "camera.macro",
                                    size: 25,
                                    active: icon == "camera.macro"))
                            }
                            
                        }
                        Divider()
                    }
                    Group {
                        Text("Email")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .placeholder(when: email.count == 0) {
                                Text("john@deere.net")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Password")
                            .foregroundColor(Color(hex:0x758EFF))
                        
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        SecureField("", text: $password)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: password.count == 0) {
                                Text("password")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Re-enter Password")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        SecureField("", text: $passwordVerify)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: passwordVerify.count == 0) {
                                Text("re-enter password")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        HStack {
                            VStack {
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    page = "signin"
                                } label: {
                                    VStack {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .background(Color(hex: 0xffb258))
                                            .clipShape(Circle())
                                        Text("Sign in?")
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: 0xffb258))
                                            .opacity(0.45)
                                    }
                                }
                            }
                            Spacer()
                            VStack {
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    if icon.count == 0 {
                                        iconError.toggle()
                                    }
                                    else if firstName.count == 0 {
                                        firstNameError.toggle()
                                    }
                                    else if lastName.count == 0 {
                                        lastNameError.toggle()
                                    }
                                    else if userName.count <= 6 {
                                        userNameError.toggle()
                                    }
                                    else if !email.contains("@") || !email.contains(".") {
                                        emailError.toggle()
                                    }
                                    else if password.count <= 6 {
                                        passwordLengthError.toggle()
                                    }
                                    else if password != passwordVerify {
                                        passwordVerifyError.toggle()
                                    }
                                    else {
                                        firebase.signUp(
                                            email: self.email,
                                            password: self.password,
                                            firstName: self.firstName,
                                            lastName: self.lastName,
                                            userName: self.userName.lowercased(),
                                            icon: self.icon
                                        )
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .background(Color(hex:0x758EFF))
                                            .clipShape(Circle())
                                        Text("Sign up")
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex:0x758EFF))
                                            .opacity(0.45)
                                    }
                                }
                                .alert("Select an icon", isPresented: $iconError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("First name required", isPresented: $firstNameError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("Last name required", isPresented: $lastNameError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("Username must be at least 7 characters", isPresented: $userNameError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("Enter a valid email address", isPresented: $emailError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("Password must be at least 7 characters", isPresented: $passwordLengthError) {
                                    Button("OK", role: .cancel) { }
                                }
                                .alert("Passwords don't match!", isPresented: $passwordVerifyError) {
                                    Button("OK", role: .cancel) { }
                                }
                            }
                        }
                    }
                }
                .padding()
            }

            if page == "signin" {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Sign in")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 2) {
                            Text("pro")
                                .font(.title3)
                                .foregroundColor(Color(hex: 0x758EFF))
                                .fontWeight(.bold)
                            Image("duck")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            Text(" tiv")
                                .font(.title3)
                                .foregroundColor(Color(hex: 0x758EFF))
                                .fontWeight(.bold)
                        }
                    }
                    Divider()
                    Group {
                        Text("Email")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("", text: $email)
                            .keyboardType(.emailAddress)
                            .foregroundColor(Color(hex: 0x758EFF))
                            .placeholder(when: email.count == 0) {
                                Text("john@deere.net")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        Text("Password")
                            .foregroundColor(Color(hex:0x758EFF))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        SecureField("", text: $password)
                            .foregroundColor(Color(hex:0x758EFF))
                            .placeholder(when: password.count == 0) {
                                Text("password")
                                    .foregroundColor(Color(hex: 0x758eff))
                                    .opacity(0.5)
                            }
                            .font(.subheadline)
                        Divider()
                    }
                    Group {
                        HStack {
                            VStack {
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    page = "signup"
                                } label: {
                                    VStack {
                                        Image(systemName: "bird.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .background(Color(hex: 0xffb258))
                                            .clipShape(Circle())
                                        Text("Sign up?")
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: 0xffb258))
                                            .opacity(0.45)
                                    }
                                }
                            }
                            Spacer()
                            VStack {
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    firebase.signIn(email: email, password: password)
                                } label: {
                                    VStack {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            .background(Color(hex:0x758EFF))
                                            .clipShape(Circle())
                                        Text("Sign in")
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex:0x758EFF))
                                            .opacity(0.45)
                                    }
                                }
                            }
                        }
                        if firebase.signInError {
                            VStack {
                                Text("something went wrong. you probably put in your password incorrectly, or need to sign up first!")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .fontWeight(.semibold)
                                    .padding()
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    firebase.signInError = false
                                } label: {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding()
                                        .background(Color(hex:0x758EFF))
                                        .clipShape(Circle())
                                        
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .onTapGesture {
            self.endEditing()
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }

}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}

