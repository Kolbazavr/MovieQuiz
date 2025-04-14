import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClientManger: NetworkClientManager(networkClient: stubNetworkClient))
        
        //When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected error")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClientManger: NetworkClientManager(networkClient: stubNetworkClient))
        
        //When
        let expectation = expectation(description: "Loading expectation")
        loader.loadMovies { result in
            //Then
            switch result {
            case .success(_):
                XCTFail("Unexpected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
                print(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
