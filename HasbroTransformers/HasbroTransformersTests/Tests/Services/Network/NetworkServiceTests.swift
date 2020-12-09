//
//  NetworkServiceTests.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import XCTest
import Foundation
@testable import HasbroTransformers

class NetworkServiceTests: XCTestCase {

    let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [FakeURLProtocol.self]
        return URLSession.init(configuration: configuration)
    }()
    
    override func setUp() {
        KeyChainService.delete(key: NetworkServiceImpl.HearderConstants.Keys.authorization)
    }
    
    override func tearDown() {
        KeyChainService.delete(key: NetworkServiceImpl.HearderConstants.Keys.authorization)
    }

    func testExecuteRequestWhenTokenIsUnavailable() {
        let networkService = NetworkServiceImpl(urlSession: urlSession)
        let expectedAPIURL = URL(string: "https://www.google.com")!
        let expectedAuthURL = APIURL.authorization
        let expectedAuthMethod = HTTPMethod.get.rawValue
        let expectedAPIMethod = HTTPMethod.post
        
        let authRequestExpectation = expectation(description: "AuthRequestExpectation")
        let apiRequestExpectation = expectation(description: "APIRequestExpectation")
        let apiResponseExpectation = expectation(description: "APIResponseExpectation")
        var hasAuthRetreived = false
        FakeURLProtocol.requestHandler = { request in
            let response: (Int, Data?, Error?)
            if !hasAuthRetreived {
                XCTAssertEqual(request.url, expectedAuthURL, "Incorrect auth URL.")
                XCTAssertEqual(request.httpMethod, expectedAuthMethod, "Incorrect auth http method.")
                hasAuthRetreived = true
                authRequestExpectation.fulfill()
                response = (200, "TOKEN".data(using: .utf8)!, nil)
            } else {
                XCTAssertEqual(request.url, expectedAPIURL, "Incorrect url received.")
                XCTAssertEqual(request.httpMethod, expectedAPIMethod.rawValue, "Incorrect http method received.")
                apiRequestExpectation.fulfill()
                response = (200, nil, nil)
            }

            return response
        }
        
        networkService.execute(url: expectedAPIURL, method: expectedAPIMethod) { result in
            switch result {
            case .failure:
                XCTFail("Failure response was not expected.")
            default: break
            }
            apiResponseExpectation.fulfill()
        }
        
        wait(for: [authRequestExpectation, apiRequestExpectation, apiResponseExpectation], timeout: 1.0, enforceOrder: true)
    }
    
    func testExecuteRequestWhenTokenIsAvailable() {
        let networkService = NetworkServiceImpl(urlSession: urlSession)
        let expectedAPIURL = URL(string: "https://www.google.com")!
        let expectedAPIMethod = HTTPMethod.post
        
        let apiRequestExpectation = expectation(description: "APIRequestExpectation")
        let apiResponseExpectation = expectation(description: "APIResponseExpectation")
        _ = KeyChainService.save(key: NetworkServiceImpl.HearderConstants.Keys.authorization, value: "TOKEN")
        FakeURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, expectedAPIURL, "Incorrect url received.")
            XCTAssertEqual(request.httpMethod, expectedAPIMethod.rawValue, "Incorrect http method received.")
            apiRequestExpectation.fulfill()
            return  (200, nil, nil)
        }
        
        networkService.execute(url: expectedAPIURL, method: expectedAPIMethod) { result in
            switch result {
            case .failure:
                XCTFail("Failure response was not expected.")
            default: break
            }
            apiResponseExpectation.fulfill()
        }
        
        wait(for: [apiRequestExpectation, apiResponseExpectation], timeout: 1.0, enforceOrder: true)
    }
    
    func testExecuteRequestFailure() {
        let networkService = NetworkServiceImpl(urlSession: urlSession)
        let apiResponseExpectation = expectation(description: "APIResponseExpectation")

        _ = KeyChainService.save(key: NetworkServiceImpl.HearderConstants.Keys.authorization, value: "TOKEN")
        FakeURLProtocol.requestHandler = { _ in
            return  (400, nil, FakeNetworkError.unexpected)
        }
        
        networkService.execute(url: URL(string: "https://www.google.com")!, method: .get) { result in
            switch result {
            case .success(_):
                XCTFail("Success case was not expected.")

            case .failure(let error):
                XCTAssertEqual(error, NetworkError.unexpected, "Incorrect error received.")
            }
            apiResponseExpectation.fulfill()
        }
        
        wait(for: [apiResponseExpectation], timeout: 1.0, enforceOrder: true)
    }

}
