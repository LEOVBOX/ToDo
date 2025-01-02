//
//  RegistrationService.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//
import Foundation

enum RegisterError: Error, LocalizedError {
    case fail
}

enum PasswordValidationError: Error, LocalizedError {
    case empty
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Password is empty."
        case .invalidFormat:
            return "Password must countain minimum 6 symbols."
        }
    }
}

enum EmailValidationError: Error, LocalizedError {
    case empty
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Email is empty."
        case .invalidFormat:
            return "Invalid Email fromat."
        }
    }
}

enum NameValidationError: Error, LocalizedError {
    case empty
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Full Name is empty."
        case .invalidFormat:
            return "Full Name may contails only letters and space"
        }
        
    }
}

class RegistrationService {
    static func validateEmail(eMail: String) -> Result<Void, Error> {
        guard !eMail.isEmpty else {
            return .failure(EmailValidationError.empty)
        }
        
        // Регулярное выражение для проверки email
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: eMail) {
            return .success(())
        } else {
            return .failure(EmailValidationError.invalidFormat)
        }
    }
    
    static func register(username: String, login: String, password: String) -> Result<UserModel, Error> {
        var userId: Int
        do {
            try KeychainManager.shared.save(key: login, value: password).get()
            userId = try SQLiteManager.shared.addUser(name: username, email: login).get()
            UserDefaultsManager.shared.saveLoggedInUser(login: login)
        }
        catch {
            return .failure(error)
        }
        return .success(UserModel(id: userId, name: username, email: login))
    }

    static func validatePassword(password: String) -> Result<Void, Error> {
        guard !password.isEmpty else {
            return .failure(PasswordValidationError.empty)
        }
        
        if password.count < 6 {
            return .failure(PasswordValidationError.invalidFormat)
        }
        return .success(())
    }
    
    static func validateName(name: String) ->Result<Void, Error> {
        guard !name.isEmpty else {
            return .failure(NameValidationError.empty)
        }
        
        let nameRegex = "^[a-zA-Zа-яА-ЯёЁ\\s]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        if namePredicate.evaluate(with: name) {
            return .success(())
        } else {
            return .failure(NameValidationError.invalidFormat)
        }
    }
}
