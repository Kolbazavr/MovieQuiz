import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private let questionsAmount: Int?
    
    private enum QuestionType: String {
        case greaterThan = "больше"
        case lowerThan = "меньше"
    }
    
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [Movie] = []
    private var uniqueIndexes: Set<Int> = []
    
    init(moviesLoader: MoviesLoading, questionsAmount: Int? = nil, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.questionsAmount = questionsAmount
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let movies):
                    self.movies = movies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        guard
            let indexToTake = getIndex(),
            let movie = movies[safe: indexToTake]
        else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let (questionText, correctAnswer) = self.createQuestion(for: movie)
            let question = QuizQuestion(movieTitle: movie.title, image: imageData, text: questionText, correctAnswer: correctAnswer)
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func createQuestion(for movie: Movie) -> (question: String, correctAnswer: Bool) {
        let rating = Float(movie.rating) ?? 0
        let lowerRating = rating.rounded(.down) - (1 - rating.truncatingRemainder(dividingBy: 1).rounded(.up))
        let upperRating = rating.rounded(.up)
        let questionRating = min(Bool.random() ? lowerRating : upperRating, 9.0)
        let questionType: QuestionType = Bool.random() ? .greaterThan : .lowerThan
        let correctAnswer: Bool = questionType == .greaterThan ? questionRating < rating : questionRating > rating
        print("Movie rating: \(rating)")
        return ("Рейтинг этого фильма \(questionType.rawValue) чем \(Int(questionRating))?", correctAnswer)
    }
    
    private func randomIndex() -> Int? {
        return (0..<movies.count).randomElement()
    }
    
    private func generateUniqueIndices(count: Int) -> Set<Int> {
        var indices: Set<Int> = []
        
        while indices.count < count {
            if let randomIndex = randomIndex() {
                indices.insert(randomIndex)
            }
        }
        return indices
    }
    
    private func getIndex() -> Int? {
        var indexToTake: Int?
        if let questionsAmount, movies.count > questionsAmount {
            if uniqueIndexes.isEmpty {
                uniqueIndexes = generateUniqueIndices(count: questionsAmount)
            }
            indexToTake = uniqueIndexes.removeFirst()
        } else {
            indexToTake = randomIndex()
        }
        return indexToTake
    }
}
