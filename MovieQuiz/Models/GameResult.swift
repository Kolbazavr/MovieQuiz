//
//  GameResult.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

struct GameResult: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    var description: String {
        "\(correct)/\(total) (\(date.dateTimeString))"
    }
    
    static func < (lhs: GameResult, rhs: GameResult) -> Bool {
        lhs.correct < rhs.correct
    }
}
