//
//  LoginView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 30.12.2024.
//

import SwiftUI

struct CustomTextField: View {
    enum TextFieldType {
        case email
        case password
        case name
    }
    
    var image: Image
    @State var isHiddenInput: Bool = false
    @State var placeholder: String
    @Binding var text: String
    @FocusState private var fieldFocused: Bool
    var validate: (String) -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(height: 42)
                .cornerRadius(5)
            
            HStack (spacing: 10) {
                image
                TextField(placeholder, text: $text)
                    .focused($fieldFocused)
                    .onSubmit {
                        validate(text)
                }
                
            }
            .padding(.horizontal, 10)
                Spacer()
            }
            
        }
}

func validateEmail(eMail: String) {
    
}

func validatePassword(password: String) {
    
}

func signIn() {
    
}

func openSignUpView() {
    
}

struct LoginView: View {
    let mainFontName = "Poppins-Regular"
    let artificialFontName = "DarumaDropOne-Regular"
    let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    
    @State var eMail: String = ""
    
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
                    CustomTextField(image: Image("lock"), placeholder: "Password", text: $eMail, validate: validatePassword)
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
                        Button (action: openSignUpView) {
                            Text("sign up")
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
