//
//  MainCoordinator.swift
//  UIKitNavigationTest
//
//  Created by ANTON ZVERKOV on 11.03.2025.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    enum Destination {
        case game
        case settings
        case highScore
        
        var viewController: UIViewController & Coordinating {
            return switch self {
            case .game: MovieQuizViewController()
            case .settings: SettingsViewController()
            case .highScore: HighScoresViewController()
            }
        }
    }
    
    func start() {
        let viewController = MainMenuViewController()
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateTo(_ destination: Destination) {
        var viewController = destination.viewController
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
