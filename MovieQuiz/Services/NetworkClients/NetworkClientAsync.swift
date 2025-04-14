import Foundation

struct NetworkClientAsync: NetworkClientProtocol {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchData(url: URL, timeOut: TimeInterval? = nil, handler: @escaping (Result<Data, any Error>) -> Void) {
        Task {
            do {
                handler(.success(try await fetch(url: url, timeOut: timeOut)))
            } catch NetworkError.codeError {
                print("Async NetworkClient: HTTP status code error")
            } catch {
                handler(.failure(error))
            }
        }
    }
    
    private func fetch(url: URL, timeOut: TimeInterval? = nil) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOut ?? 10
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.codeError
        }
        return data
    }
}
