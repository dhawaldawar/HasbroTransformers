//
//  TransformerAPIImpl.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

struct ResponseGetAllTransformers: Decodable {
    let transformers: [Transformer]
}

class TransformerAPIImpl: TransformerAPI {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchAllTransformers(completion: @escaping (Result<[Transformer], NetworkError>) -> Void) {
        networkService.execute(url: APIURL.transformer, method: .get) { (result: Result<ResponseGetAllTransformers, NetworkError>) in
            let result = result.map { $0.transformers }
            completion(result)
        }
    }
    
    func create(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        networkService.execute(url: APIURL.transformer, method: .post, requestParameter: transformer) { (result: Result<Transformer, NetworkError>) in
            let result = result.flatMap { receivedTransformer -> Result<Void, NetworkError> in
                guard transformer == receivedTransformer else {
                    return Result.failure(.unexpected)
                }

                return Result.success(())
            }
            completion(result)
        }
    }

    func update(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        networkService.execute(url: APIURL.transformer, method: .put, requestParameter: transformer) { (result: Result<Transformer, NetworkError>) in
            let result = result.flatMap { receivedTransformer -> Result<Void, NetworkError> in
                guard transformer == receivedTransformer else {
                    return Result.failure(.unexpected)
                }
                
                return Result.success(())
            }
            completion(result)
        }
    }
    
    func delete(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = APIURL.transformer.appendingPathComponent(transformer.id)
        networkService.execute(url: url, method: .delete) { result in
            completion(result)
        }
    }
 
}
