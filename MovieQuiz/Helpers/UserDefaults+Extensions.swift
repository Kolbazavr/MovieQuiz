//
//  UserDefaults+Extensions.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

extension UserDefaults {
    
    func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}
