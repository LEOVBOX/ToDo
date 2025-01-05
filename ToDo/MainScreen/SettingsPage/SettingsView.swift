//
//  SettingsView.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel()
    @State var showSignInView = false
    @State private var isPressed: Bool = false // Для анимации
    
    private func logout() {
        viewModel.logout()
        showSignInView = true
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            VStack {
                Text("Settings")
                    .font(Font.custom(mainFontName, size: 18))
                    .foregroundStyle(.white)
                
                VStack(spacing: 95) {
                    VStack {
                        Button (action: {}) {
                            HStack {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Profile")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.white)
                                Spacer()
                                
                                Image("chevronRightSettings")
                                    .resizable()
                                    .frame(width: 9, height: 15)
                                    .tint(Color(0x0EA5E9))
                            }
                        }
                        separatorLine()
                        Button (action: {}) {
                            HStack {
                                Image("conversations")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Conversations")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.white)
                                Spacer()
                                
                                Image("chevronRightSettings")
                                    .resizable()
                                    .frame(width: 9, height: 15)
                                    .tint(Color(0x0EA5E9))
                            }
                        }
                        separatorLine()
                        Button (action: {}) {
                            HStack {
                                Image("projects")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Projects")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.white)
                                Spacer()
                                
                                Image("chevronRightSettings")
                                    .resizable()
                                    .frame(width: 9, height: 15)
                                    .tint(Color(0x0EA5E9))
                            }
                        }
                        separatorLine()
                        
                        Button (action: {}) {
                            HStack {
                                Image("terms")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("Political and Terms")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(.white)
                                Spacer()
                                
                                Image("chevronRightSettings")
                                    .resizable()
                                    .frame(width: 9, height: 15)
                                    .tint(Color(0x0EA5E9))
                            }
                        }
                        separatorLine()
                    }
                    
                    Button(action: logout) {
                        ZStack {
                            Rectangle()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(width: 226, height: 42)
                                .foregroundStyle(.white)
                            HStack {
                                Image("logout")
                                    .resizable()
                                    .frame(width: 25, height: 20)
                                Text("Logout")
                                    .font(Font.custom(mainFontName, size: 16))
                                    .foregroundStyle(Color(0xDC4343))
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showSignInView) {
                        SignInView()
                    }
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding()
        }
    }
    
    @ViewBuilder
    private func separatorLine() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color(0xFFFFFF, alpha: 0.25))
    }
}

#Preview {
    SettingsView()
}
