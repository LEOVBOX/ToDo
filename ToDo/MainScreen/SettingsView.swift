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
    
    private func logout() {
        viewModel.logout()
        showSignInView = true
    }
    
    var body: some View {
        ZStack {
            VStack {
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
        }
    }
}

#Preview {
    SettingsView()
}
