//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

struct AlertModel {
    
    private let correctAnswers: Int
    private let questionsAmount: Int
    private let gamesCount: Int?
    private let record: String?
    private let accuracy: Double?
    let title: String
    let buttonText: String
    let completion: () -> Void
    
    init(correctAnswers: Int, questionsAmount: Int, gamesCount: Int?, record: String?, accuracy: Double?, title: String = "Этот раунд окончен!", buttonText: String = "Сыграть ещё раз", completion: @escaping () -> Void) {
        self.correctAnswers = correctAnswers
        self.questionsAmount = questionsAmount
        self.gamesCount = gamesCount
        self.record = record
        self.accuracy = accuracy
        self.title = title
        self.buttonText = buttonText
        self.completion = completion
    }
    
    private var yourScore: String {
        "Ваш результат: \(correctAnswers)/\(questionsAmount)"
    }
    
    private var totalGamesPlayed: String {
        "Количество сыгранных квизов: \(gamesCount ?? 0)"
    }
    
    private var bestScore: String {
        "Рекорд: \(record ?? "пока нет такого")"
    }
    
    private var totalAccuracy: String {
        "Средняя точность: " + String(format: "%.2f", accuracy ?? 0) + "%"
    }
    
    var message: String {
        return "\(yourScore)\n\(totalGamesPlayed)\n\(bestScore)\n\(totalAccuracy)"
    }
}
