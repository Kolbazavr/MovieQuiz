//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 22.02.2025.
//

import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
//    init(imageName: String, question: String, questionNumber: String) {
//        self.image = UIImage(named: imageName)!
//        self.question = question
//        self.questionNumber = questionNumber
//    }
    
    init(quizQuestion: QuizQuestion, number currentQuestionIndex: Int, of questionsCount: Int) {
        self.image = UIImage(named: quizQuestion.image)!
        self.question = quizQuestion.text
        self.questionNumber = "\(currentQuestionIndex + 1)/\(questionsCount)"
    }
}
