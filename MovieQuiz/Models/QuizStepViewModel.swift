import UIKit

struct QuizStepViewModel {
    let image: UIImage?
    let question: String
    let questionNumber: String
    let movieTitle: String
    
    init(quizQuestion: QuizQuestion, number questionNumber: Int, of questionsCount: Int) {
        self.image = UIImage(data: quizQuestion.image)
        self.question = quizQuestion.text
        self.questionNumber = "\(questionNumber)/\(questionsCount)"
        self.movieTitle = quizQuestion.movieTitle
    }
}
