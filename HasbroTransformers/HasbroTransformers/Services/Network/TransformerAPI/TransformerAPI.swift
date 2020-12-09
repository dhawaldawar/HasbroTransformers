//
//  TransformerAPI.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

protocol TransformerAPI {
    
    /// Fetches all the available transformers.
    func fetchAllTransformers(completion: @escaping (Result<[Transformer], NetworkError>) -> Void)
    
    
    /// Creates a new transformer, `id` would be assigned by the system.
    /// - Parameters:
    ///   - transformer: `Transformer` that should be created.
    func create(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void)
    
    
    /// Updates existing transformer.
    /// - Parameters:
    ///   - transformer: `Transformer` that should be updated.
    func update(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void)
    
    
    /// Deletes an existing transformer.
    /// - Parameters:
    ///   - transformer: `Transformer` that should be deleted.
    func delete(transformer: Transformer, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
