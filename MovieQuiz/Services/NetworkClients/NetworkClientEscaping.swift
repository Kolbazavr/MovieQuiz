import Foundation

struct NetworkClientEscaping: NetworkClientProtocol {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchData(url: URL, timeOut: TimeInterval? = nil, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOut ?? 10
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode
            else {
                handler(.failure(error ?? NetworkError.codeError))
                return
            }
            handler(.success(data))
        }
        .resume()
    }
}
