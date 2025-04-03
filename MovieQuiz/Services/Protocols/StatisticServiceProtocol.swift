import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestScore: GameResult { get }
    var highScores: [GameResult] { get }
    var totalAccuracy: Double { get }
    var questionsAnsweredTotal: Int { get }
    
    func store(gameResult: GameResult)
    func eraseAll()
}
