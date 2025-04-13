import Foundation

protocol NetworkClientProtocol {
    func fetchData(url: URL, timeOut: TimeInterval?, handler: @escaping (Result<Data, Error>) -> Void)
}
