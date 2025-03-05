import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
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
        var buttonsActive: (Bool, Bool) {
            return switch self {
            case .correct, .incorrect: (false, false)
            case .noAnswer: (true, true)
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
    
    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestionNumber += 1
        currentQuestion = question
        let viewModel = QuizStepViewModel(quizQuestion: question, number: currentQuestionNumber, of: questionsAmount)
        
        DispatchQueue.main.async { [weak self] in
            self?.updateUI(with: viewModel)
            self?.updateQuestionState(for: .noAnswer)
        }
    }
    
    // MARK: AlertPresenterDelegate
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    private func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    private func updateQuestionState(for state: QuestionState) {
        imageView.layer.borderColor = state.color
        (noButton.isEnabled, yesButton.isEnabled) = state.buttonsActive
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        updateQuestionState(for: isCorrect ? .correct : .incorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
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
        statisticService?.store(result: GameResult(correct: correctAnswers, total: questionsAmount, date: Date()))
        let resultsModel = AlertModel(
            correctAnswers: correctAnswers,
            questionsAmount: questionsAmount,
            gamesCount: statisticService?.gamesCount,
            record: statisticService?.bestGame.description,
            accuracy: statisticService?.totalAccuracy) { [weak self] in
                self?.resetQuiz()
            }
        alertPresenter?.makeAlert(for: resultsModel)
    }
    
    private func resetQuiz() {
        currentQuestionNumber = 0
        correctAnswers = 0
        loadQuestion()
    }
    
    private func evaluateAnswer(buttonTypePressed: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: buttonTypePressed == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: false)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: true)
    }

    //Hidden Feature! (5 seconds)
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
        statisticService?.eraseAll()
        print("UserDefaults erased")
    }
}
