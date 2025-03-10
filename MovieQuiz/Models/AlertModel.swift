//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: () -> Void
}
