//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

final class StatisticService {
    
    private let storage = UserDefaults.standard
    private let scoresListLength: Int = 7
    
    private enum Keys: String {
        case highScores
        case gamesCount
        case correctCount
        case questionsAnsweredTotal
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    var gamesCount: Int{
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var questionsAnsweredTotal: Int {
        get { storage.integer(forKey: Keys.questionsAnsweredTotal.rawValue) }
        set { storage.set(newValue, forKey: Keys.questionsAnsweredTotal.rawValue) }
    }
    
    var highScores: [GameResult] {
        get { storage.getThingy(forKey: Keys.highScores.rawValue, as: [GameResult].self) ?? [] }
        set { storage.setThingy(newValue, forKey: Keys.highScores.rawValue) }
    }
    
    var bestScore: GameResult {
        highScores.first ?? GameResult()
    }
    
    var totalAccuracy: Double {
        guard questionsAnsweredTotal > 0 else { return 0 }
        return (Double(correctCount) / Double(questionsAnsweredTotal)) * 100
    }
    
    private var correctCount: Int {
        get { storage.integer(forKey: Keys.correctCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.correctCount.rawValue) }
    }
    
    func store(gameResult: GameResult) {
        gamesCount += 1
        correctCount += gameResult.correct
        questionsAnsweredTotal += gameResult.total
        updateHighScores(with: gameResult)
    }
    
    func eraseAll() {
        storage.removeAll()
    }
    
    private func updateHighScores(with newScore: GameResult) {
        guard newScore.correct > 0 else { return }
        var scores = highScores
        let insertIndex = scores.firstIndex(where: { $0 <= newScore })
        if let insertIndex {
            scores.insert(newScore, at: insertIndex)
        } else if scores.count < scoresListLength {
            scores.append(newScore)
        }
        if scores.count > scoresListLength { scores.removeLast() }
        highScores = scores
    }
}

