//
//  SignUpView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 31.12.2024.
//

import SwiftUI


struct SignUpView: View {
    @State private var showSignIn = false
    @ObservedObject var viewModel: SignUpViewModel = SignUpViewModel()
    
    private let mainFontName = "Poppins-Regular"
    private let artificialFontName = "DarumaDropOne-Regular"
    private let backgroundGradient = LinearGradient(gradient: Gradient(colors: [Color(0x1254AA), Color(0x05243E)]), startPoint: .top, endPoint: .bottom)
    
    @State private var eMail: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var signUpError: Error? = nil
    @State private var showAlert = false
    @State private var showHomeView = false
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name, email, password
    }
    
    private func signUp() {
        do {
            try viewModel.signUp(name: fullName, email: eMail, password: password)
            showHomeView = true
        }
        catch {
            signUpError = error
            showAlert = true
            return
        }
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
                            Text("Welcome to")
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
                    CustomTextField(
                        image: Image("person"),
                        placeholder: "Full Name",
                        text: $fullName
                    )
                    .focused($focusedField, equals: .name)
                    
                    CustomTextField(
                        image: Image("e-mail"),
                        placeholder: "E-mail",
                        text: $eMail
                    )
                    .focused($focusedField, equals: .email)
                    
                    CustomTextField(
                        image: Image("lock"),
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    
                }
                .padding(.top, 50)
                
                // Button and hint
                VStack (spacing: 20) {
                    Button (action: signUp) {
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
                    .fullScreenCover(isPresented: $showHomeView) {
                        if let signedUpUser = viewModel.signedUpUser {
                            MainView(viewModel: MainViewModel(homePageViewModel: HomePageViewModel(user: signedUpUser, databaseManager: SQLiteManager.shared), takskPageViewModel: TasksPageViewModel(user: signedUpUser, databaseManager: SQLiteManager.shared)))
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
                            SignInView()
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
                    message: Text(signUpError?.localizedDescription ?? "Неизвестная ошибка"),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
    }
}

#Preview {
    SignUpView()
}
