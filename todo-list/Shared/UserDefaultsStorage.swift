//
//  UserDefaultsStorage.swift
//  todo-list
//
//  Created by Мария Анисович on 26.05.2025.
//

import UIKit

protocol StorageForKeyProtocol {
    func bool(forKey: String) -> Bool
    func set(_ value: Bool, forKey: String)
}

final class UserDefaultsStorage: StorageForKeyProtocol {
    static let shared = UserDefaultsStorage()
    
    func bool(forKey: String) -> Bool {
        UserDefaults.standard.bool(forKey: forKey)
    }
    
    func set(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
}
