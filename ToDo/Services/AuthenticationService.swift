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



class AuthenticationService {
    static func authenticate(login: String, password: String) -> Result<UserModel, AuthenticationError> {
        guard !login.isEmpty, !password.isEmpty else {
            return .failure(.emptyFields)
        }
        
        guard let storedPassword = KeychainManager.shared.get(key: login) else {
            return .failure(.userNotFound)
        }
        
        if storedPassword != password {
            return .failure(.invalidPassword)
        }
        

        var user: UserModel
        do {
            user = try SQLiteManager.shared.getUser(login: login).get()
            UserDefaultsManager.shared.saveLoggedInUser(login: user.email)
        }
        catch {
            return .failure(.userNotFound)
        }
        
        return .success(user)
    }
    
    
}
