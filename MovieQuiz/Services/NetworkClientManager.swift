import Foundation

final class NetworkClientManager {
    
    let networkClient: NetworkClientProtocol
    
    init(networkClientType: LoaderType) {
        switch networkClientType {
        case .async:
            if #available(iOS 15, *) {
                self.networkClient = NetworkClientAsync()
            } else {
                print("iOS 15 or later is required for async network client -> using escaping instead")
                self.networkClient = NetworkClientEscaping()
            }
        case .combine:
            if #available(iOS 13, *) {
                self.networkClient = NetworkClientCombine()
            } else {
                print("iOS 13 or later is required for combine network client -> using escaping instead")
                self.networkClient = NetworkClientEscaping()
            }
        case .escaping:
            self.networkClient = NetworkClientEscaping()
        }
    }
    
    func fetchMoviesData(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        networkClient.fetchData(url: url, handler: handler)
    }
}
