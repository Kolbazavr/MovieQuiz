import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func missing(_ element: String) -> String {
        "Where the F is \(element)?"
    }
    
    func startGame() {
        app.buttons["NewGameButton"].tap()
    }
    
    func testYesButton() throws {
        startGame()
        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), missing("First Poster"))
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let yesButton = app.buttons["Yes"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 2), missing("Yes button"))
        yesButton.tap()
        
        let secondPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), missing("Second Poster"))
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let label = app.staticTexts["Index"]
        XCTAssertTrue(label.waitForExistence(timeout: 2), missing("Question Index"))
        let labelParts = label.label.split(separator: "/")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        XCTAssertEqual(labelParts.count, 2)
        XCTAssertEqual(labelParts.first, "2")
    }
    
    func testNoButton() throws {
        startGame()
        let firstPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), missing("First Poster"))
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let noButton = app.buttons["No"]
        XCTAssertTrue(noButton.waitForExistence(timeout: 2), missing("No button"))
        noButton.tap()
        
        let secondPoster = app.images["Poster"]
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), missing("Second Poster"))
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let label = app.staticTexts["Index"]
        XCTAssertTrue(label.waitForExistence(timeout: 2), missing("Question Index"))
        let labelParts = label.label.split(separator: "/")
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        XCTAssertEqual(labelParts.count, 2)
        XCTAssertEqual(labelParts.first, "2")
    }
    
    func testGameOver() {
        startGame()
        
        let testQuestionCount: Int = 10
        UserDefaults.standard.set(testQuestionCount, forKey: "questionsCount")
        
        let yesButton = app.buttons["Yes"]
        let poster = app.images["Poster"]
        
        for _ in 0..<testQuestionCount {
            XCTAssertTrue(yesButton.waitForExistence(timeout: 2), missing("Yes button"))
            yesButton.tap()
            XCTAssertTrue(poster.waitForExistence(timeout: 3), missing("Poster"))
        }
        
        let alert = app.alerts["GameOver"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3), missing("GameOverAlert"))
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        startGame()
        
        let testQuestionCount: Int = 10
        UserDefaults.standard.set(testQuestionCount, forKey: "questionsCount")
        
        let yesButton = app.buttons["Yes"]
        let poster = app.images["Poster"]
        
        for _ in 0..<testQuestionCount {
            XCTAssertTrue(yesButton.waitForExistence(timeout: 2), missing("Yes button"))
            yesButton.tap()
            XCTAssertTrue(poster.waitForExistence(timeout: 3), missing("Poster"))
        }
        
        let alert = app.alerts["GameOver"]
        alert.buttons.firstMatch.tap()
        let label = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(poster.waitForExistence(timeout: 3), missing("New Game Poster"))
        XCTAssertEqual(label.label, "1/10")
    }
}
