//
//  SignUpViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var signedUpUser: UserModel?
    
    func signUp(name: String, email: String, password: String) throws {
        do {
            try RegistrationService.validateName(name: name).get()
            try RegistrationService.validateEmail(eMail: email).get()
            try RegistrationService.validatePassword(password: password).get()
            let signedUp = try RegistrationService.register(username: name, login: email, password: password).get()
            signedUpUser = signedUp
        }
        catch {
            throw error
        }
    }
}
