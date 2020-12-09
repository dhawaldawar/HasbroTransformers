//
//  NetworkServiceFakeImpl.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
@testable import HasbroTransformers

class NetworkServiceFakeImpl: NetworkService {
    
    var executeWithJSONResponseHandler: ((
        _ url: URL,
        _ method: HTTPMethod,
        _ httpBody: Data?
    ) -> Result<Decodable, NetworkError>)!
    
    var executeHandler: ((
        _ url: URL,
        _ method: HTTPMethod
    ) -> Result<Void, NetworkError>)!
    
    
    func execute<ResponseObject: Decodable>(
        url: URL,
        method: HTTPMethod,
        httpBody: Data?,
        completion: @escaping (Result<ResponseObject, NetworkError>) -> Void
    ) {
        let result = executeWithJSONResponseHandler(url, method, httpBody).flatMap { decodable -> Result<ResponseObject, NetworkError> in
            guard let responseObject = decodable as? ResponseObject else{
                return Result.failure(NetworkError.unexpected)
            }
            
            return Result.success(responseObject)
        }
        completion(result)
    }
    
    func execute(
        url: URL,
        method: HTTPMethod,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        let result = executeHandler(url, method)
       completion(result)
    }
    
    
}
