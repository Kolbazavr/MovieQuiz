import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
    init(quizQuestion: QuizQuestion, number questionNumber: Int, of questionsCount: Int) {
        self.image = UIImage(named: quizQuestion.image)!
        self.question = quizQuestion.text
        self.questionNumber = "\(questionNumber)/\(questionsCount)"
    }
}
