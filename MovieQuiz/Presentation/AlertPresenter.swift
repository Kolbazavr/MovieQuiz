//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by ANTON ZVERKOV on 04.03.2025.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func makeAlert(for model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        if let alertId = model.alertId {
            alert.view.accessibilityIdentifier = alertId
        }
        
        for button in model.buttons {
            let action = UIAlertAction(title: button.buttonText, style: .default) { _ in
                button.action()
            }
            alert.addAction(action)
        }
        
        delegate?.presentAlert(alert: alert)
    }
}
