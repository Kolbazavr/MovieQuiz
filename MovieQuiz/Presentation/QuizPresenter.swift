import UIKit

final class QuizPresenter {
    
    private weak var viewController: (QuizViewControllerProtocol & Coordinating)?
    
    init(viewController: (QuizViewControllerProtocol & Coordinating)?) {
        self.viewController = viewController
        self.userSettings = UserSettings()
        self.statisticService = StatisticService()
        
        self.questionsAmount = userSettings?.questionsCount ?? 10
        let loader = userSettings?.loaderType ?? .escaping
                                             
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(loader: loader), questionsAmount: questionsAmount, delegate: self)
        self.alertPresenter = AlertPresenter(delegate: self)
        self.commandRecognizer = (userSettings?.voiceControlEnabled ?? false) ? SpeechRecognizer(delegate: self) : nil
        self.loadQuizData()
    }
    
    var isLoading: Bool = false {
        didSet { viewController?.toggleLoadingState(to: isLoading) }
    }
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var userSettings: UserSettingsProtocol?
    
    private var commandRecognizer: SpeechRecognizer?
    
    private var currentQuestionNumber: Int = .zero
    private var correctAnswers: Int = .zero
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int
    
    func showNextQuestionOrResults() {
        currentQuestionNumber == questionsAmount ? showResults() : loadQuestion()
    }
    
    func evaluateAnswer(buttonTypePressed: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = buttonTypePressed == currentQuestion.correctAnswer
        correctAnswers += isCorrect ? 1 : 0
        viewController?.showAnswerResult(for: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            showNextQuestionOrResults()
        }
    }
    
    @MainActor private func changeVoiceState(isEnabled: Bool) {
        isEnabled ? commandRecognizer?.startTranscribing() : commandRecognizer?.stopTranscribing()
    }
    
    private func loadQuestion() {
        isLoading = true
        questionFactory?.requestNextQuestion()
    }
    
    private func loadQuizData() {
        questionFactory?.loadData()
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
            alertId: "GameOver",
            buttons: [button]
        )
        alertPresenter?.makeAlert(for: resultsModel)
    }
    
    private func resetQuiz() {
        currentQuestionNumber = .zero
        correctAnswers = .zero
        loadQuestion()
    }
    
    private func showNetworkError(message: String) {
        let buttonRetry = AlertButtonModel(buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.resetQuiz()
            self.loadQuizData()
        }
        let buttonGoBack = AlertButtonModel(buttonText: "Ну и ладно") { [weak self] in
            self?.viewController?.coordinator?.navigateBack()
        }
        let networkErrorModel = AlertModel(title: "Ошибка", message: message, buttons: [buttonRetry, buttonGoBack])
        alertPresenter?.makeAlert(for: networkErrorModel)
    }
}

//MARK: - QuestionFactoryDelegate
extension QuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        isLoading = false
        currentQuestionNumber += 1
        currentQuestion = question
        let viewModel = QuizStepViewModel(quizQuestion: question, number: currentQuestionNumber, of: questionsAmount)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(with: viewModel)
            self?.changeVoiceState(isEnabled: true)
        }
    }
    
    func didLoadDataFromServer() {
        loadQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}

//MARK: - AlertPresenterDelegate
extension QuizPresenter: AlertPresenterDelegate {
    func presentAlert(alert: UIAlertController) {
        viewController?.showAlert(alert: alert)
    }
}

//MARK: - VoiceCommandRecognizerDelegate
extension QuizPresenter: VoiceCommandRecognizerDelegate {
    func commandRecognized(_ command: Bool) {
        evaluateAnswer(buttonTypePressed: command)
        viewController?.pressButton(command)
    }
}


