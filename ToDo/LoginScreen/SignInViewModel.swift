//
//  SignInViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var signedInUser: UserModel?
    
    func signIn(login: String, password: String) throws {
        do {
            let result = try AuthenticationService.authenticate(login: login, password: password).get()
            signedInUser = result
        }
        catch {
            throw error
        }
    }
}
