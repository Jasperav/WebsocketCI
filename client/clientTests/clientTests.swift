
import XCTest
@testable import client
import Foundation

class clientTests: XCTestCase {
    func testExample() throws {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://127.0.0.1:9002")!)
        webSocketTask.resume()
        
        let expectationSend = expectation(description: "send")
        
        webSocketTask.send(.string("hi"), completionHandler: { error in
            XCTAssertNil(error)
            
            print("TEST: \(error)")
            
            expectationSend.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let expectationReceive = expectation(description: "receive")
        
        webSocketTask.receive(completionHandler: { message in
            switch message {
            case .success(let success):
                switch success {
                case .data(_):
                    fatalError()
                case .string(let response):
                    XCTAssertEqual("hi", response)
                    
                    print("TEST2: \(response)")
                    
                    expectationReceive.fulfill()
                @unknown default:
                    fatalError()
                }
            case .failure(_):
                XCTAssert(false, "Got failure")
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
