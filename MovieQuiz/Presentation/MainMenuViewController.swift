//
//  MainMenuViewController.swift
//  UIKitNavigationTest
//
//  Created by ANTON ZVERKOV on 10.03.2025.
//

import UIKit
import AVFoundation // REMOVE!!!

final class MainMenuViewController: UIViewController {
    
    var coordinator: MainCoordinator?

    private let newGameButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let highScoreButton = UIButton(type: .system)
    private let menuTitleLabel = UILabel()
    private let footNoteLabel = UILabel()
    
    @objc private func newGameButtonTapped() {
        coordinator?.navigateTo(.game)
    }
    @objc private func settingsButtonTapped() {
        coordinator?.navigateTo(.settings)
    }
    @objc private func highScoreButtonTapped() {
        coordinator?.navigateTo(.highScore)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        playVideoBackground()
    }
}

extension MainMenuViewController {
    private func setupUI() {
        view.backgroundColor = .ypBackground
        
        menuTitleLabel.text = "MovieQuiz"
        menuTitleLabel.font = UIFont(name: "YSDisplay-Bold", size: 40)
        menuTitleLabel.textColor = .ypWhite
        menuTitleLabel.textAlignment = .center
        menuTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTitleLabel)
        
        footNoteLabel.text = "© 2025 Practicum Mobile"
        footNoteLabel.font = UIFont(name: "YSDisplay-Medium", size: 13)
        footNoteLabel.textColor = .ypWhite
        footNoteLabel.textAlignment = .center
        footNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footNoteLabel)
        
        newGameButton.configure(title: "Новая игра")
        newGameButton.setImage(UIImage(systemName: "arcade.stick"), for: .normal)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        
        settingsButton.configure(title: "Настройки")
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        highScoreButton.configure(title: "Рекорды")
        highScoreButton.setImage(UIImage(systemName: "star"), for: .normal)
        highScoreButton.addTarget(self, action: #selector(highScoreButtonTapped), for: .touchUpInside)
        
        let menuStackView = UIStackView(arrangedSubviews: [newGameButton, settingsButton, highScoreButton])
        menuStackView.axis = .vertical
        menuStackView.distribution = .fillEqually
        menuStackView.spacing = 20
        
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuStackView)

        NSLayoutConstraint.activate([
            menuTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            menuTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            footNoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            footNoteLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            newGameButton.heightAnchor.constraint(equalToConstant: 60),
            settingsButton.heightAnchor.constraint(equalToConstant: 60),
            highScoreButton.heightAnchor.constraint(equalToConstant: 60),
            
            menuStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuStackView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    //MARK: - Video
    func playVideoBackground() {
            if let path = Bundle.main.path(forResource: "SigmaB", ofType: "mov") {
                let url = URL(fileURLWithPath: path)
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.bounds
                playerLayer.videoGravity = .resizeAspectFill
                self.view.layer.insertSublayer(playerLayer, at: 0)
                player.play()
                
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(playerItemDidReachEnd(_:)),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: player.currentItem)
            }
        }

        @objc func playerItemDidReachEnd(_ notification: Notification) {
            if let playerItem = notification.object as? AVPlayerItem {
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
            }
        }
    
}
