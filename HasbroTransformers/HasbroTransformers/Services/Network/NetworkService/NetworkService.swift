//
//  APIClient.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error, LocalizedError {
    case timeout
    case authorizationFailed
    case unexpected
    
    var errorDescription: String? {
        switch self {
        case .timeout:
            return Localizations.Messages.networkErrorTimeout
            
        case .authorizationFailed:
            return Localizations.Messages.networkErrorAuthorization
            
        case .unexpected:
            return Localizations.Messages.networkErrorUnexpected
        }
    }
}

protocol NetworkService {
    
    /// Executes an api call through the raw request, it is not recomended to call directly, please use extensions.
    /// Please note, before making a call, it will check for the authorization.
    /// - Parameters:
    ///   - url: api URL where the request would be called.
    ///   - method: HTTP method
    ///   - httpBody: HTTP body data.
    func execute<ResponseObject: Decodable>(
        url: URL,
        method: HTTPMethod,
        httpBody: Data?,
        completion: @escaping (Result<ResponseObject, NetworkError>) -> Void
    )
    
    /// Executes an api call, it will first check for the authorization tocken and if it's unavailable then it will pull the token and then make a request.
    /// - Parameters:
    ///   - url: api URL where the request would be called.
    ///   - method: HTTP method.
    func execute(
        url: URL,
        method: HTTPMethod,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    )
    
}

extension NetworkService {
    
    func execute<ResponseObject: Decodable>(
        url: URL,
        method: HTTPMethod,
        completion: @escaping (Result<ResponseObject, NetworkError>) -> Void
    ) {
        execute(url: url, method: method, httpBody: nil, completion: completion)
    }
    
    func execute<RequestObject: Encodable, ResponseObject: Decodable>(
        url: URL,
        method: HTTPMethod,
        requestParameter: RequestObject,
        completion: @escaping (Result<ResponseObject, NetworkError>) -> Void
    ) {
        do {
            let data = try JSONEncoder().encode(requestParameter)
            execute(url: url, method: method, httpBody: data, completion: completion)
        } catch {
            Log.assertionFailure("Unable to encode JSON request parameter.")
            DispatchQueue.main.async {
                completion(.failure(.unexpected))
            }
        }
    }
}
