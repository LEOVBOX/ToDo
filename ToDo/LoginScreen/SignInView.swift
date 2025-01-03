//
//  LoginView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 30.12.2024.
//

import SwiftUI

struct SignInView: View {
    @State private var showSignUp = false
    @State private var eMail: String = ""
    @State private var password: String = ""
    @State private var signInError: Error? = nil
    @State private var showAlert = false
    @State private var showMainView = false
    @State private var signedInUser: UserModel? = nil
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password
    }
    
    func signIn() {
        do {
            signedInUser = try AuthenticationService.authenticate(login: eMail, password: password).get()
        }
        catch {
            showAlert = true
            signInError = error
            return
        }
        showMainView = true
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
                    CustomTextField(image: Image("e-mail"), placeholder: "E-mail", text: $eMail)
                        .focused($focusedField, equals: .email)
                    CustomTextField(image: Image("lock"), placeholder: "Password", text: $password, isSecure: true)
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
                    .fullScreenCover(isPresented: $showMainView) {
                        HomeView(viewModel: HomePageViewModel(user: signedInUser!, databaseManager: SQLiteManager.shared))
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
            }
            .padding(.horizontal, 26)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(signInError?.localizedDescription ?? "Неизвестная ошибка"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    SignInView()
}
