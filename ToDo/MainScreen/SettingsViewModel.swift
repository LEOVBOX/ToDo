//
//  SettingsViewModel.swift
//  ToDo
//
//  Created by Леонид Шайхутдинов on 04.01.2025.
//

import Foundation

class SettingsViewModel: ObservableObject {
    func logout() {
        UserDefaultsManager.shared.logout()
    }
}
