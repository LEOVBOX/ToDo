//
//  UserDefaultsManager.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 02.01.2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let userKey = "loggedInUser"
    private let guideKey = "skipGuide"
    private let signedInStatus = "signedIn"
    
    private init() {}
    
    func isSignedIn() {
        UserDefaults.standard.bool(forKey: signedInStatus)
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: signedInStatus)
        UserDefaults.standard.set(nil, forKey: userKey)
    }
    
    func saveLoggedInUser(login: String?) {
        UserDefaults.standard.set(login, forKey: userKey)
        UserDefaults.standard.set(true, forKey: signedInStatus)
    }
    
    func getLoggedInUser() -> String? {
        UserDefaults.standard.string(forKey: userKey)
    }
    
    func skipGuide(skipGuide: Bool) {
        UserDefaults.standard.set(skipGuide, forKey: guideKey)
        //print("UserDefaults.shared: \(UserDefaults.standard.dictionaryRepresentation())")
    }
    
    func skipGuide() -> Bool {
        //print("UserDefaults.shared: \(UserDefaults.standard.dictionaryRepresentation())")
        return UserDefaults.standard.bool(forKey: guideKey)
    }
    
}
