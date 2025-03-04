import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionNumber = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private enum QuestionState {
        case correct
        case incorrect
        case noAnswer
        
        var color: CGColor {
            return switch self {
            case .correct: UIColor.ypGreen.cgColor
            case .incorrect: UIColor.ypRed.cgColor
            case .noAnswer: UIColor.clear.cgColor
            }
        }
        var buttonsActive: Bool {
            return switch self {
            case .correct, .incorrect: false
            case .noAnswer: true
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
        
        loadQuestion()
    }
    
    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        self.currentQuestion = question
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
        noButton.isEnabled = state.buttonsActive
        yesButton.isEnabled = state.buttonsActive
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
        if currentQuestionNumber == questionsAmount - 1 {
            showResults()
        } else {
            currentQuestionNumber += 1
            loadQuestion()
        }
    }
    
    private func loadQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func showResults() {
        let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let resultsModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] in
                self?.resetQuiz()
                self?.loadQuestion()
            }
        alertPresenter?.makeAlert(for: resultsModel)
    }
    
    private func resetQuiz() {
        currentQuestionNumber = 0
        correctAnswers = 0
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
     
}
