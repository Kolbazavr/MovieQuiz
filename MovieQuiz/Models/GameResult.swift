//
//  GameResult.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

struct GameResult: Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    init(correct: Int = 0, total: Int = 0, date: Date = Date()) {
        self.correct = correct
        self.total = total
        self.date = date
    }
    
    var description: String {
        "\(correct)/\(total) (\(date.dateTimeString))"
    }
    
    static func < (lhs: GameResult, rhs: GameResult) -> Bool {
        lhs.correct < rhs.correct
    }
}
