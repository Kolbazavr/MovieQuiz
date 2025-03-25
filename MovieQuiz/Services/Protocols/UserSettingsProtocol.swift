//
//  UserSettingsProtocol.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 14.03.2025.
//

import Foundation

protocol UserSettingsProtocol {
    var questionsCount: Int { get set }
    var loaderType: LoaderType? { get set }
    var voiceControlEnabled: Bool { get set }
}
