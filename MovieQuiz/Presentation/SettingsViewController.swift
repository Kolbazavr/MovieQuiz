//
//  SettingsViewController.swift
//  UIKitNavigationTest
//
//  Created by ANTON ZVERKOV on 11.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController, AlertPresenterDelegate, Coordinating {
    
    var coordinator: Coordinator?
    
    private var userSettings: UserSettingsProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private let questionCountVariants: [Int] = [10, 20, 1_000_000]
    
    private let titleLabel = UILabel()
    private let loaderLabel = UILabel()
    private let loaderTypeMenuButton = UIButton(type: .system) //check type if in configure ext
    private let questionCountLabel = UILabel()
    private let questionCountMenuButton = UIButton(type: .system)
    private let voiceControlLabel = UILabel()
    private let voiceControlSwitch = UISwitch()
    private let resetScoresButton = UIButton(type: .system)
    
    private func selectLoader(_ loader: LoaderType) {
        userSettings?.loaderType = loader
        updateLoaderMenu()
    }
    
    private func selectQuestionCount(_ count: Int) {
        guard count != userSettings?.questionsCount else { return }
        if count == questionCountVariants.last {
            makeCountAlert()
        } else {
            userSettings?.questionsCount = count
            updateQuestionCountMenu()
        }
    }
    
    private func resetScores() {
        statisticService?.eraseAll()
    }
    
    @objc private func resetScoresTapped() {
        makeResetAlert()
    }
    
    @objc private func makeResetAlert() {
        let title = "Точно?"
        let okButton = AlertButtonModel(buttonText: "Удалить", action: { [weak self] in
            self?.resetScores()
        })
        let cancelButton = AlertButtonModel(buttonText: "Отмена", action: {})

        let message = "Может не надо?"
           
        let resultsModel = AlertModel(
            title: title,
            message: message,
            buttons: [okButton, cancelButton]
        )
        alertPresenter?.makeAlert(for: resultsModel)
    }
    
    @objc private func switchFlipped(sender: UISwitch) {
        userSettings?.voiceControlEnabled = sender.isOn
    }
    
    private func makeCountAlert() {
        let title = "Серьезно?"
        let okButton = AlertButtonModel(buttonText: "Люблю боль", action: { [weak self] in
            self?.userSettings?.questionsCount = self?.questionCountVariants.last ?? 10
            self?.updateQuestionCountMenu()
        })
        let cancelButton = AlertButtonModel(buttonText: "Ха-ха, смешно", action: {})

        let message = "Это шутка вообще-то..."
           
        let resultsModel = AlertModel(
            title: title,
            message: message,
            buttons: [okButton, cancelButton]
        )
        alertPresenter?.makeAlert(for: resultsModel)
    }
    
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userSettings = UserSettings()
        self.alertPresenter = AlertPresenter(delegate: self)
        self.statisticService = StatisticService()
        
        setupUI()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBackgroundSolid
        
        titleLabel.text = "Настройки"
        titleLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        titleLabel.textColor = .ypWhite
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loaderLabel.text = "Способ загрузки вопросов:"
        loaderLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        loaderLabel.textColor = .ypWhite
        
        loaderTypeMenuButton.setTitleColor(.ypWhite, for: .normal)
        loaderTypeMenuButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        let loaderStackView = UIStackView(arrangedSubviews: [loaderLabel, loaderTypeMenuButton])
        loaderStackView.axis = .horizontal
        loaderStackView.distribution = .equalSpacing
        
        questionCountLabel.text = "Количество вопросов:"
        questionCountLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionCountLabel.textColor = .ypWhite
        
        questionCountMenuButton.setTitle("10", for: .normal)
        questionCountMenuButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionCountMenuButton.setTitleColor(.ypWhite, for: .normal)
        
        let questionsStackView = UIStackView(arrangedSubviews: [questionCountLabel, questionCountMenuButton])
        questionsStackView.axis = .horizontal
        questionsStackView.distribution = .equalSpacing
        
        voiceControlLabel.text = "Управление голосом:"
        voiceControlLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        voiceControlLabel.textColor = .ypWhite
        
        voiceControlSwitch.onTintColor = .ypGreen
        voiceControlSwitch.addTarget(self, action: #selector(switchFlipped(sender:)), for: .valueChanged)
        
        let voiceControlStackView = UIStackView(arrangedSubviews: [voiceControlLabel, voiceControlSwitch])
        voiceControlStackView.axis = .horizontal
        voiceControlStackView.distribution = .equalSpacing
        
        resetScoresButton.setTitle("Сбросить результаты", for: .normal)
        resetScoresButton.setTitleColor(.red, for: .normal)
        resetScoresButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        resetScoresButton.addTarget(self, action: #selector(makeResetAlert), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [loaderStackView, questionsStackView, voiceControlStackView, resetScoresButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ])
    }
    
    private func updateUI() {
        updateLoaderMenu()
        updateQuestionCountMenu()
        updateVoiceControlSettings()
    }
    
    private func updateLoaderMenu() {
        let selectedLoader = userSettings?.loaderType ?? LoaderType.escaping
        let menuItems: [UIAction] = LoaderType.allCases.map { loaderType in
            UIAction(title: loaderType.rawValue, state: selectedLoader == loaderType ? .on : .off) { [weak self] _ in
                self?.selectLoader(loaderType)
            }
        }
        let menu = UIMenu(title: "Загрузчик", children: menuItems)
        loaderTypeMenuButton.setTitle(selectedLoader.rawValue, for: .normal)
        loaderTypeMenuButton.menu = menu
        loaderTypeMenuButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateQuestionCountMenu() {
        let questionCount = userSettings?.questionsCount ?? 10
        let menuItems: [UIAction] = questionCountVariants.map { count in
            UIAction(title: count.withSpaces, state: questionCount == count ? .on : .off) { [weak self] _ in
                self?.selectQuestionCount(count)
            }
        }
        let menu = UIMenu(title: "Количество вопросов", children: menuItems)
        questionCountMenuButton.setTitle(questionCount.withSpaces, for: .normal)
        questionCountMenuButton.menu = menu
        questionCountMenuButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateVoiceControlSettings() {
        let voiceControlEnabled = userSettings?.voiceControlEnabled ?? false
        voiceControlSwitch.isOn = voiceControlEnabled
    }

}
