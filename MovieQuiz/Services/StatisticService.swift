//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

final class StatisticService {
    
    private let storage = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
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
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue) else {
                return GameResult(correct: 0, total: 0, date: Date())
            }
            do {
                let decodedResult = try decoder.decode(GameResult.self, from: data)
                return decodedResult
            } catch {
                print("Decoding failed: \(error.localizedDescription)")
                return GameResult(correct: 0, total: 0, date: Date())
            }
        }
        set {
            do {
                let encodedData = try encoder.encode(newValue)
                storage.set(encodedData, forKey: Keys.bestGame.rawValue)
            } catch {
                print("Encoding failed: \(error.localizedDescription)")
            }
        }
    }
    
    var totalAccuracy: Double {
        guard gamesCount > 0 else { return 0 }
        return (Double(correctCount) / Double(gamesCount * 10)) * 100
    }
    
    func store(result: GameResult) {
        gamesCount += 1
        correctCount += result.correct
        bestGame = max(bestGame, result)
    }
}
