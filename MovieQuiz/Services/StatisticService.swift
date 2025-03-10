//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

final class StatisticService {
    
    private let storage = UserDefaults.standard
    
    private enum Keys: String {
        case bestScore
        case bestScoreDate
        case gamesCount
        case correctCount
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int{
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    private var correctCount: Int {
        get { storage.integer(forKey: Keys.correctCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.correctCount.rawValue) }
    }
    
    var bestScore: Int {
        get { storage.integer(forKey: Keys.bestScore.rawValue) }
        set { storage.set(newValue, forKey: Keys.bestScore.rawValue) }
    }
    
    var bestScoreDate: String {
        get { storage.string(forKey: Keys.bestScoreDate.rawValue) ?? Date().dateTimeString }
        set { storage.set(newValue, forKey: Keys.bestScoreDate.rawValue) }
    }
    
    var totalAccuracy: Double {
        guard gamesCount > 0 else { return 0 }
        return (Double(correctCount) / Double(gamesCount * 10)) * 100
    }
    
    func store(correctAnswers: Int) {
        gamesCount += 1
        correctCount += correctAnswers
        guard correctAnswers > bestScore else { return }
        bestScore = correctAnswers
        bestScoreDate = Date().dateTimeString
    }
    
    func eraseAll() {
        storage.removeAll()
    }
}

