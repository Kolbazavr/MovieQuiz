import UIKit

protocol QuizViewControllerProtocol: AnyObject {
    func showAnswerResult(for isCorrect: Bool)
    func showQuestion(with step: QuizStepViewModel)
    func showAlert(alert: UIAlertController)
    func toggleLoadingState(to isLoading: Bool)
    func pressButton(_ buttonType: Bool)
}
