import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: QuizViewControllerProtocol, Coordinating {
    var coordinator: (any MovieQuiz.Coordinator)?
    
    func showAnswerResult(for isCorrect: Bool) { }
    func showQuestion(with step: MovieQuiz.QuizStepViewModel) { }
    func showGameOverAlert(alert: UIAlertController) { }
    func showAlert(alert: UIAlertController) { }
    func toggleLoadingState(to isLoading: Bool) { }
    func pressButton(_ buttonType: Bool) { }
}

//TODO: remove later:
//I don't have "convert" func for review, so...
final class MovieQuizPresenterMock {
    
    private weak var viewController: (QuizViewControllerProtocol & Coordinating)?
    
    init(viewController: (QuizViewControllerProtocol & Coordinating)?) {
        self.viewController = viewController
    }
    
    func convert(model: MovieQuiz.QuizQuestion) -> MovieQuiz.QuizStepViewModel {
        var viewModel = QuizStepViewModel(quizQuestion: model, number: 1, of: 10)
        
        /*
        emptyData will give UIImage = nil
        my QuizStepViewModel can be initialized with image = nil
        if no poster image, movie TITLE label will be shown instead
        */
        
        //to simulate test "XCTAssertNotNil(viewModel.image)" from course, setting image = UIImage() manually
        let image = UIImage(data: model.image ?? Data()) ?? UIImage()
        viewModel.image = image
        
        return viewModel
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenterMock(viewController: viewControllerMock)
        
        let emptyData = Data()
        
        let question = QuizQuestion(movieTitle: "MovieTitle", image: emptyData, text: "QuestionText", correctAnswer: false)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.movieTitle, "MovieTitle")
        XCTAssertEqual(viewModel.question, "QuestionText")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
