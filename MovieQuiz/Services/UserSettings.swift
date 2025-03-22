//
//  UserSettings.swift
//  UIKitNavigationTest
//
//  Created by ANTON ZVERKOV on 12.03.2025.
//

import Foundation

final class UserSettings {
    
    private let defaults = UserDefaults.standard
    
    private enum Keys: String {
        case questionsCount
        case loaderType
        case voiceControlEnabled
    }
}

extension UserSettings: UserSettingsProtocol {
    var questionsCount: Int {
        get { defaults.object(forKey: Keys.questionsCount.rawValue) as? Int ?? 10 }
        set { defaults.set(newValue, forKey: Keys.questionsCount.rawValue) }
    }
    
    var loaderType: LoaderType? {
        get {
            guard let rawValue = defaults.string(forKey: Keys.loaderType.rawValue) else { return nil }
            return LoaderType(rawValue: rawValue)
        }
        set { defaults.set(newValue?.rawValue, forKey: Keys.loaderType.rawValue) }
    }
    
    var voiceControlEnabled: Bool {
        get { defaults.bool(forKey: Keys.voiceControlEnabled.rawValue) }
        set { defaults.set(newValue, forKey: Keys.voiceControlEnabled.rawValue) }
    }
    
}
