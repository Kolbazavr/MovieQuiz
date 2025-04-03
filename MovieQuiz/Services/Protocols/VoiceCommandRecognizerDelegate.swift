//
//  VoiceCommandRecognizerDelegate.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 18.03.2025.
//

import Foundation

protocol VoiceCommandRecognizerDelegate: AnyObject {
    func commandRecognized(_ command: Bool)
}
