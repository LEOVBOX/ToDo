//
//  AuthenticationManager.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 01.01.2025.
//
import Foundation

enum AuthenticationError: Error, LocalizedError {
    case userNotFound
    case invalidPassword
    case emptyFields

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found."
        case .invalidPassword:
            return "Invalid password."
        case .emptyFields:
            return "Please fill in all fields."
        }
    }
}

enum RegisterError: Error, LocalizedError {
    case fail
}

class AuthenticationService {
    static func authenticate(login: String, password: String) -> Result<Void, AuthenticationError> {
        guard !login.isEmpty, !password.isEmpty else {
            return .failure(.emptyFields)
        }
        
        guard let storedPassword = KeychainManager.shared.get(key: login) else {
            return .failure(.userNotFound)
        }
        
        if storedPassword != password {
            return .failure(.invalidPassword)
        }
        
        return .success(())
    }
    
    static func register(username: String, login: String, password: String) -> Result<Void, RegisterError> {
        if KeychainManager.shared.save(key: username, value: password) {
            return .success(())
        }
        else {
            return .failure(RegisterError.fail)
        }
    }
}
