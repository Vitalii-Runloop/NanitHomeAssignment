//
//  AppUserSettings.swift
//  NanitHomeAssignment
//
//  Created by Vitalii on 13.06.2022.
//

import Foundation

struct AppUserSettings {
    enum UserSettingsKey: String {
        case userModel
    }
    
    static var userModel: UserModel? {
        get {
            return decodeAndGetValue(forKey: .userModel)
        }
        set {
            encodeAndSet(newValue, forKey: .userModel)
        }
    }
    
}

private extension AppUserSettings {
    
    static func encodeAndSet<Value: Codable>(_ value: Value, forKey key: UserSettingsKey) {
        let encodedValue = try? JSONEncoder().encode(value)
        UserDefaults.standard.set(encodedValue, forKey: key.rawValue)
    }
    
    static func decodeAndGetValue<Value: Decodable>(forKey key: UserSettingsKey) -> Value? {
        guard let valueData = UserDefaults.standard.value(forKey: key.rawValue) as? Data,
            let value = try? JSONDecoder().decode(Value.self, from: valueData) else {
                return nil
        }
        
        return value
    }
    
}
