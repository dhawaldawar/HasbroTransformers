//
//  TransformerAPITests.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import XCTest
@testable import HasbroTransformers

class TransformerAPITests: XCTestCase {

    let networkServiceFake = NetworkServiceFakeImpl()

    func testCreateTransformer() {
        let transformerAPI = TransformerAPIImpl(networkService: networkServiceFake)
        let transformer = Transformer(name: "test", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 4, rank: 5, courage: 6, firepower: 7, skill: 8)
        
        networkServiceFake.executeWithJSONResponseHandler = { url, method, httpBody in
            XCTAssertEqual(url, APIURL.transformer, "Incorrect URL")
            XCTAssertEqual(method, HTTPMethod.post, "Incorrect method")
            
            guard let httpBody = httpBody else {
                XCTFail("HTTPBody was expected")
                return .failure(.unexpected)
            }
            
            let expectedHTTPBody = try! JSONEncoder().encode(transformer)
            XCTAssertEqual(httpBody, expectedHTTPBody, "Incorrect http body")
            return .success(transformer)
        }
        
        let responseExpectation = expectation(description: "responseExpectation")
        transformerAPI.create(transformer: transformer) { result in
            guard case Result.success = result else {
                XCTFail("Failure response was not expected.")
                return
            }
            
            responseExpectation.fulfill()
        }
        
        wait(for: [responseExpectation], timeout: 1.0)
    }
    
    func testUpdateTransformer() {
        let transformerAPI = TransformerAPIImpl(networkService: networkServiceFake)
        let transformer = Transformer(name: "test", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 4, rank: 5, courage: 6, firepower: 7, skill: 8)
        
        networkServiceFake.executeWithJSONResponseHandler = { url, method, httpBody in
            XCTAssertEqual(url, APIURL.transformer, "Incorrect URL")
            XCTAssertEqual(method, HTTPMethod.put, "Incorrect method")
            
            guard let httpBody = httpBody else {
                XCTFail("HTTPBody was expected")
                return .failure(.unexpected)
            }
            
            let expectedHTTPBody = try! JSONEncoder().encode(transformer)
            XCTAssertEqual(httpBody, expectedHTTPBody, "Incorrect http body")
            return .success(transformer)
        }
        
        let responseExpectation = expectation(description: "responseExpectation")
        transformerAPI.update(transformer: transformer) { result in
            guard case Result.success = result else {
                XCTFail("Failure response was not expected.")
                return
            }
            
            responseExpectation.fulfill()
        }
        
        wait(for: [responseExpectation], timeout: 1.0)
    }
    
    func testFetchTransformer() {
        let transformerAPI = TransformerAPIImpl(networkService: networkServiceFake)
        let transformer = Transformer(name: "test", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 4, rank: 5, courage: 6, firepower: 7, skill: 8)
        
        networkServiceFake.executeWithJSONResponseHandler = { url, method, httpBody in
            XCTAssertEqual(url, APIURL.transformer, "Incorrect URL")
            XCTAssertEqual(method, HTTPMethod.get, "Incorrect method")
            XCTAssertNil(httpBody, "HTTP body was not expected")
            return .success(ResponseGetAllTransformers(transformers: [transformer]))
        }
        
        let responseExpectation = expectation(description: "responseExpectation")
        transformerAPI.fetchAllTransformers { result in
            switch result {
            case .success(let transformers):
                XCTAssertEqual(transformers, [transformer], "Incorrect objects received")
                
            case .failure(_):
                XCTFail("Failure case was not expected")
            }
            
            responseExpectation.fulfill()
        }
        
        wait(for: [responseExpectation], timeout: 1.0)
    }
}
