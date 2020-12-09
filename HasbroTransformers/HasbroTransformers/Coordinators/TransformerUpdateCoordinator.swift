//
//  TransformerUpdateCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

/// Factory to create objects required to update transformer's details.
struct TransformerUpdateCoordinator {
    
    static func viewModel(
        transformer: Transformer?
    ) -> TransformerUpdateViewModel {
        let transformerAPI = TransformerAPIImpl(networkService: NetworkServiceManager.shared.service)
        return TransformerUpdateViewModelImpl(transformer: transformer, transformerAPI: transformerAPI)
    }
    
}
