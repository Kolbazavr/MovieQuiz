import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
    func loadPoster(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
