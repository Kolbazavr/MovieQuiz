import UIKit

final class MovieQuizViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    init() {
        self.userSettings = UserSettings()
        self.statisticService = StatisticService()
        
        self.questionsAmount = userSettings?.questionsCount ?? 10
                                             
        super.init(nibName: nil, bundle: nil)
        
        self.questionFactory = QuestionFactory(delegate: self)
        self.alertPresenter = AlertPresenter(delegate: self)
        self.commandRecognizer = (userSettings?.voiceControlEnabled ?? false) ? SpeechRecognizer(delegate: self) : nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var userSettings: UserSettingsProtocol?
    
    private var commandRecognizer: SpeechRecognizer?
    
    private var currentQuestionNumber = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    
    private let questionsAmount: Int
    
    private let yesButton = UIButton(type: .system)
    private let noButton = UIButton(type: .system)
    private let questionTextLabel = UILabel()
    private let questionNumberLabel = UILabel()
    private let questionTitleLabel = UILabel()
    private let imageView = UIImageView()
    private let menuButton = UIButton(type: .system)
    
    private enum QuestionState {
        case correct, incorrect, noAnswer
        
        var color: CGColor {
            return switch self {
            case .correct: UIColor.ypGreen.cgColor
            case .incorrect: UIColor.ypRed.cgColor
            case .noAnswer: UIColor.clear.cgColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadQuestion()
    }

    private func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        questionTextLabel.text = viewModel.question
        questionNumberLabel.text = viewModel.questionNumber
    }
    
    private func updateBorder(for state: QuestionState) {
        imageView.layer.borderColor = state.color
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        updateBorder(for: isCorrect ? .correct : .incorrect)
        changeStateButton(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        currentQuestionNumber == questionsAmount ? showResults() : loadQuestion()
    }
    
    private func loadQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func showResults() {
        let gameResult: GameResult = .init(correct: correctAnswers, total: questionsAmount)
        statisticService?.store(gameResult: gameResult)
        
        let title = "Этот раунд окончен!"
        let yourScore = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let totalGamesPlayed = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
        let bestScore = "Рекорд: \(statisticService?.bestScore.description ?? "пока нет такого :(")"
        let totalAccuracy = "Средняя точность: " + String(format: "%.2f", statisticService?.totalAccuracy ?? 0) + "%"
        let message = "\(yourScore)\n\(totalGamesPlayed)\n\(bestScore)\n\(totalAccuracy)"
        
        let button = AlertButtonModel(buttonText: "Сыграть ещё раз") { [weak self] in
                self?.resetQuiz()
        }
           
        let resultsModel = AlertModel(
            title: title,
            message: message,
            buttons: [button]
        )
        alertPresenter?.makeAlert(for: resultsModel)
        
    }
    
    private func resetQuiz() {
        currentQuestionNumber = .zero
        correctAnswers = .zero
        loadQuestion()
    }
    
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    private func animateButtonPress(_ button: UIButton) {
        UIView.animate(withDuration: 0.4) {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn) {
            button.transform = .identity
        }
    }
    
    private func changeVoiceState(isEnabled: Bool) {
        isEnabled ? commandRecognizer?.startTranscribing() : commandRecognizer?.stopTranscribing()
    }
    
    private func evaluateAnswer(buttonTypePressed: Bool) {
        guard let currentQuestion else { return }
        animateButtonPress(buttonTypePressed ? yesButton : noButton)
        showAnswerResult(isCorrect: buttonTypePressed == currentQuestion.correctAnswer)
    }
    
    @objc private func noButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: false)
    }
    
    @objc private func yesButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: true)
    }
}

//MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestionNumber += 1
        currentQuestion = question
        let viewModel = QuizStepViewModel(quizQuestion: question, number: currentQuestionNumber, of: questionsAmount)
        
        DispatchQueue.main.async { [weak self] in
            
            self?.updateUI(with: viewModel)
            self?.updateBorder(for: .noAnswer)
            self?.changeStateButton(isEnabled: true)
            
            self?.changeVoiceState(isEnabled: true)
        }
    }
}

//MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}

//MARK: - VoiceCommandRecognizerDelegate
extension MovieQuizViewController: VoiceCommandRecognizerDelegate {
    func commandRecognized(_ command: Bool) {
        evaluateAnswer(buttonTypePressed: command)
    }
}

//MARK: - SetupUI
extension MovieQuizViewController {
    private func setupUI() {
        setupUIElements()
        setupMenu()
    }
    
    private func setupUIElements() {
        view.backgroundColor = .ypBackgroundSolid
        
        questionTitleLabel.text = "Вопрос:"
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.textColor = .ypWhite
        
        questionNumberLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionNumberLabel.textColor = .ypWhite
        
        menuButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let titleStackView = UIStackView(arrangedSubviews: [questionTitleLabel, questionNumberLabel, menuButton])
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 5
        
        noButton.configure(title: "Нет")
        noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        yesButton.configure(title: "Да")
        yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 20
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 8
        imageView.backgroundColor = .gray
        
        questionTextLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionTextLabel.textColor = .ypWhite
        questionTextLabel.textAlignment = .center
        questionTextLabel.numberOfLines = 0
        
        let mainStackView = UIStackView(arrangedSubviews: [titleStackView, imageView, questionTextLabel, buttonsStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 20
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/2).isActive = true
    }
    
    private func setupMenu() {
        let menu = UIMenu(children: [
            UIAction(title: "Сереже надо выйти", image: UIImage(systemName: "house")) { [weak self] _ in
                self?.coordinator?.navigateBack()
            }
        ])
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    
    
}
