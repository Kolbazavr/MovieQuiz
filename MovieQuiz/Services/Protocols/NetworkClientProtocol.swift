import Foundation

protocol NetworkClientProtocol {
    func fetchData(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
