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
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
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
        get {
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue)
            
            return GameResult(correct: correct, total: total, date: date as? Date ?? Date())
        }
        set {
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
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

