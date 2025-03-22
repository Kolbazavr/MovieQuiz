import Foundation

struct GameResult: Codable {
    
    let correct: Int
    let total: Int
    let date: String
    
    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total) * 100
    }
    
    var description: String {
        "\(correct)/\(total) (\(date))"
    }
    
    init(correct: Int = 0, total: Int = 0, date: String = Date().dateTimeString) {
        self.correct = correct
        self.total = total
        self.date = date
    }
}

extension GameResult: Comparable {
    
    static func < (lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.accuracy < rhs.accuracy
    }
    
}
