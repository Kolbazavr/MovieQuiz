//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(result: GameResult)
    func eraseAll()
}
