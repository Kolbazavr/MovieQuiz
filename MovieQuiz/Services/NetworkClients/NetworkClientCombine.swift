import Foundation
import Combine

final class NetworkClientCombine: NetworkClientProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        print("Loading with combine")
        fetch(url: url)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    handler(.failure(error))
                }
                
            }, receiveValue: { data in
                handler(.success(data))
            })
            .store(in: &cancellables)
    }
    
    
    private func fetch(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
//            .decode(type: MostPopularMovies.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
