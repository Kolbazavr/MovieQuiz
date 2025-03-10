//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestScore: Int { get }
    var bestScoreDate: String { get }
    var totalAccuracy: Double { get }
    
    func store(correctAnswers: Int)
    func eraseAll()
}
