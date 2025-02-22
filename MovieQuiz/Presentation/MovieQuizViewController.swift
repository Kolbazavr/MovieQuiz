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
    
    private enum highlightState {
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
        loadQuestion()
    }
    
    private func updateUI(with viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    private func updateBorder(for state: highlightState) {
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
    
    private func evaluateAnswer(isCorrect: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: isCorrect == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        evaluateAnswer(isCorrect: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        evaluateAnswer(isCorrect: true)
    }
     
}


//MARK: - Models

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
    init(imageName: String, question: String, questionNumber: String) {
        self.image = UIImage(named: imageName)!
        self.question = question
        self.questionNumber = questionNumber
    }
    
    init(quizQuestion: QuizQuestion, number currentQuestionIndex: Int, of questionsCount: Int) {
        self.image = UIImage(named: quizQuestion.image)!
        self.question = quizQuestion.text
        self.questionNumber = "\(currentQuestionIndex + 1)/\(questionsCount)"
    }
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
