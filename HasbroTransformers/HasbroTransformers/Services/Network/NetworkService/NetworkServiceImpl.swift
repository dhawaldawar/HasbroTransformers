//
//  NetworkServiceImpl.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    
    enum HearderConstants {
        enum Keys {
            static let authorization = "Authorization"
            static let contentType = "Content-Type"
        }
        
        enum Values {
            static let contentType = "application/json"
            static func authorization(token: String) -> String {
                "Bearer \(token)"
            }
        }
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func execute(
        url: URL,
        method: HTTPMethod,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        retrieveToken { [weak self] result in
            switch result {
            case .success(let token):
                self?.callAPI(
                    url: url,
                    method: method,
                    httpHeaderFields: self?.prepareHeaderFields(token: token)
                ) { result in
                    let result = result.map { _ -> Void in }
                    completion(result)
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func execute<ResponseObject: Decodable>(
        url: URL,
        method: HTTPMethod,
        httpBody: Data?,
        completion: @escaping (Result<ResponseObject, NetworkError>) -> Void
    ) {
        retrieveToken { [weak self] result in
            switch result {
            case .success(let token):
                self?.callAPI(
                    url: url,
                    method: method,
                    httpBody: httpBody,
                    httpHeaderFields: self?.prepareHeaderFields(token: token)
                ) { result in
                   let result = result.flatMap { data -> Result<ResponseObject, NetworkError> in
                        do {
                            let responseObject = try JSONDecoder().decode(ResponseObject.self, from: data)
                            return .success(responseObject)
                        } catch {
                            Log.assertionFailure("Failed to decode json object \nerror: \(error)\nData String: \(String(describing: String(data: data, encoding: .utf8)))")
                            return .failure(.unexpected)
                        }
                    }

                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    private func retrieveToken(completion: @escaping (Result<String, NetworkError>) -> Void) {
        if let token = KeyChainService.load(key: HearderConstants.Keys.authorization) {
            completion(.success(token))
            return
        }

        Log.info("Retrieving authorization token.")
        callAPI(url: APIURL.authorization) { result in
            switch result {
            case .success(let data):
                
                guard let token = String(data: data, encoding: .utf8), KeyChainService.save(key: HearderConstants.Keys.authorization, value: token) else {
                    DispatchQueue.main.async { completion(.failure(.authorizationFailed)) }
                    return
                }
                
                Log.info("Received authorization token.")
                _ = KeyChainService.save(key: HearderConstants.Keys.authorization, value: token)
                
                DispatchQueue.main.async { completion(.success(token)) }

            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    private func callAPI(
        url: URL,
        method: HTTPMethod = .get,
        httpBody: Data? = nil,
        httpHeaderFields: [String: String]? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        Log.info("Executing request url: \(url))")
        
        let urlRequest: URLRequest = {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.httpBody = httpBody
            urlRequest.allHTTPHeaderFields = httpHeaderFields
            return urlRequest
        }()
        
        urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                Log.error("Failed to perform request: \(url), error: \(error)")
                DispatchQueue.main.async { completion(.failure(.unexpected)) }
                return
            }
            
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                Log.assertionFailure("Unable to convert URLResponse into HTTPURLResponse.")
                DispatchQueue.main.async { completion(.failure(.unexpected)) }
                return
            }

            if 200..<300 ~= urlResponse.statusCode, let data = data {
                Log.info("Received response for url: \(String(describing: urlRequest.url))")
                DispatchQueue.main.async { completion(.success(data)) }
            } else {
                let error: NetworkError = urlResponse.statusCode == 408 ? .timeout : .unexpected
                Log.error("Failed to perform request, status code: \(urlResponse.statusCode), error: \(error)")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    private func prepareHeaderFields(token: String) -> [String: String] {
        return [
            HearderConstants.Keys.authorization: HearderConstants.Values.authorization(token: token),
            HearderConstants.Keys.contentType: HearderConstants.Values.contentType
        ]
    }
    
}
