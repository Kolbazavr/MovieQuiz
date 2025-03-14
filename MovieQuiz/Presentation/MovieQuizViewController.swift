import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestionNumber = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    
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
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        self.questionFactory = QuestionFactory(delegate: self)
        self.alertPresenter = AlertPresenter(delegate: self)
        self.statisticService = StatisticService()
        
        loadQuestion()
    }

    private func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
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
        statisticService?.store(correctAnswers: correctAnswers)
        
        let title = "Этот раунд окончен!"
        let buttonText = "Сыграть ещё раз"
        let yourScore = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let totalGamesPlayed = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
        let bestScore = "Рекорд: \(statisticService?.bestScore ?? 0)/\(questionsAmount) (\(statisticService?.bestScoreDate ?? ""))"
        let totalAccuracy = "Средняя точность: " + String(format: "%.2f", statisticService?.totalAccuracy ?? 0) + "%"
        let message = "\(yourScore)\n\(totalGamesPlayed)\n\(bestScore)\n\(totalAccuracy)"
           
        let resultsModel = AlertModel(
            title: title,
            message: message,
            buttonText: buttonText) { [weak self] in
                self?.resetQuiz()
            }
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
    
    private func evaluateAnswer(buttonTypePressed: Bool) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: buttonTypePressed == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: false)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: true)
    }

    //Hidden Feature! (5 seconds)
    @IBAction private func longPress(_ sender: UILongPressGestureRecognizer) {
        statisticService?.eraseAll()
        print("UserDefaults erased")
    }
}

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
        }
    }
}

extension MovieQuizViewController: AlertPresenterDelegate {
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
