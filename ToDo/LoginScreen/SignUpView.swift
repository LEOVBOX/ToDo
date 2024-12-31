//
//  SignUpView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 31.12.2024.
//

import SwiftUI

func validateName(name: String) {
    
}



struct SignUpView: View {
    @State private var showSignIn = false
    
    private let mainFontName = "Poppins-Regular"
    private let artificialFontName = "DarumaDropOne-Regular"
    private let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    
    @State private var eMail: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                // Header
                VStack (spacing: 25) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 83, height: 83)
                    VStack (spacing: 4) {
                        HStack {
                            Text("Welcome Back to")
                                .font(Font.custom(mainFontName, size: 25))
                                .foregroundStyle(.white)
                            Text("DO IT")
                                .font(Font.custom(artificialFontName, size: 25))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        HStack {
                            Text("create an account and Join us now!")
                                .font(Font.custom(mainFontName, size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 30)
                
                // Input fields
                VStack (spacing: 40) {
                    CustomTextField(image: Image("person"), placeholder: "Full name", text: $fullName, validate: validateName)
                    CustomTextField(image: Image("e-mail"), placeholder: "E-mail", text: $eMail, validate: validateEmail)
                    CustomTextField(image: Image("lock"), placeholder: "Password", text: $password, validate: validatePassword, isSecure: true)
                    
                }
                .padding(.top, 50)
                
                // Button and hint
                VStack (spacing: 20) {
                    Button (action: signIn) {
                        ZStack {
                            Rectangle()
                                .fill(Color(0x0EA5E9))
                                .frame(height: 42)
                                .cornerRadius(10)
                            Text("sign up")
                                .font(Font.custom(mainFontName, size: 18))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                        Button ("sign in") {
                            showSignIn = true
                        }
                        .fullScreenCover(isPresented: $showSignIn) {
                            LoginView()
                        }

                    }
                    
                }
                .padding(.top, 70)
                
                Spacer()
            }.padding(.horizontal, 26)
            
        }
    }
}

#Preview {
    SignUpView()
}
