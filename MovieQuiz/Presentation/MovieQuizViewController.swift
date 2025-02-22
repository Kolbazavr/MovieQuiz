import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    
    private enum HighlightState {
        case correct
        case incorrect
        case noAnswer
        
        var color: CGColor {
            switch self {
            case .correct:
                return UIColor.ypGreen.cgColor
            case .incorrect:
                return UIColor.ypRed.cgColor
            case .noAnswer:
                return UIColor.clear.cgColor
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .correct, .incorrect:
                return 8
            case .noAnswer:
                return 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        loadQuestion()
    }
    
    private func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    private func updateBorder(for state: HighlightState) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = state.color
        imageView.layer.borderWidth = state.borderWidth
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        updateBorder(for: isCorrect ? .correct : .incorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            loadQuestion()
        }
    }
    
    private func loadQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = QuizStepViewModel(quizQuestion: currentQuestion, number: currentQuestionIndex, of: questions.count)
        updateUI(with: viewModel)
        updateBorder(for: .noAnswer)
    }
    
    private func showResults() {
        let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
        let resultsViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        showAlert(resultsViewModel)
    }
    
    private func showAlert(_ result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.resetQuiz()
            self.loadQuestion()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func evaluateAnswer(buttonTypePressed: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: buttonTypePressed == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: false)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        evaluateAnswer(buttonTypePressed: true)
    }
     
}
