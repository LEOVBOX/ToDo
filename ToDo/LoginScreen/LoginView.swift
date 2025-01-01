//
//  LoginView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 30.12.2024.
//

import SwiftUI


func validateEmail(eMail: String) {
    
}

func validatePassword(password: String) {
    
}

func signIn() {
    
}

func openSignUpView() {
    
}

struct LoginView: View {
    @State private var showSignUp = false
    private let mainFontName = "Poppins-Regular"
    private let artificialFontName = "DarumaDropOne-Regular"
    private let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    
    @State private var eMail: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            
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
                            Text("Have an other productive day !")
                                .font(Font.custom(mainFontName, size: 18))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 30)
                
                // Input fields
                VStack (spacing: 55) {
                    CustomTextField(image: Image("e-mail"), placeholder: "E-mail", text: $eMail, validate: validateEmail)
                        .focused($focusedField, equals: .email)
                    CustomTextField(image: Image("lock"), placeholder: "Password", text: $password, validate: validatePassword, isSecure: true)
                        .focused($focusedField, equals: .password)
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
                            Text("sign in")
                                .font(Font.custom(mainFontName, size: 18))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    HStack {
                        Text("Don’t have an account?")
                            .font(Font.custom(mainFontName, size: 14))
                            .foregroundStyle(.white)
                        Button ("sing up") {
                            showSignUp = true
                        }
                        .fullScreenCover(isPresented: $showSignUp) {
                            SignUpView()
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
    LoginView()
}
