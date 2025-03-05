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
        case bestGame
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
    
    var bestGame: GameResult {
        get { storage.getThingy(forKey: Keys.bestGame.rawValue, as: GameResult.self) ?? GameResult() }
        set { storage.setThingy(newValue, forKey: Keys.bestGame.rawValue) }
    }
    
    var totalAccuracy: Double {
        guard gamesCount > 0 else { return 0 }
        return (Double(correctCount) / Double(gamesCount * 10)) * 100
    }
    
    func store(result: GameResult) {
        gamesCount += 1
        correctCount += result.correct
        bestGame = max(result, bestGame)
    }
    
    func eraseAll() {
        storage.removeAll()
    }
}
