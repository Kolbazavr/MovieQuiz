import Foundation

struct MoviesLoader: MoviesLoading {
    private let networkClientManger: NetworkClientManager
    
    init(loader: LoaderType) {
        self.networkClientManger = NetworkClientManager(networkClientType: loader)
    }
    
    private enum EmptyDataError: Error, LocalizedError {
        case emptyData(String)
        
        var errorDescription: String? {
            switch self {
            case .emptyData(let message):
                return message
            }
        }
    }
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClientManger.fetchMoviesData(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let moviesData):
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(MostPopularMovies.self, from: moviesData)
                    guard !movies.items.isEmpty else {
                        throw EmptyDataError.emptyData(movies.errorMessage)
                    }
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
