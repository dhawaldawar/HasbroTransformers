//
//  FakeURLProtocol.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

enum FakeNetworkError: Error {
    case unexpected
}

class FakeURLProtocol: URLProtocol {
  
    static var requestHandler: ((URLRequest) -> (Int, Data?, Error?))!
    
    override class func canInit(with request: URLRequest) -> Bool {
      return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
      return request
    }

    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: FakeNetworkError.unexpected)
            return
        }

        let (statusCode, data, error) = FakeURLProtocol.requestHandler(request)
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {
      
    }
    
    
}
