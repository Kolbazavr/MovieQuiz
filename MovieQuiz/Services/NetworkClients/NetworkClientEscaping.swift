import Foundation

struct NetworkClientEscaping: NetworkClientProtocol {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchData(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        print("Loading with escaping")
        URLSession.shared.dataTask(with: url) { data, response, error in
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
