import Foundation

struct NetworkClientAsync: NetworkClientProtocol {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchData(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        print("Loading with async")
        Task {
            do {
                handler(.success(try await fetch(url: url)))
            } catch NetworkError.codeError {
                print("Async NetworkClient: HTTP status code error")
            } catch {
                handler(.failure(error))
            }
        }
    }
    
    private func fetch(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.codeError
        }
        return data
    }
}
