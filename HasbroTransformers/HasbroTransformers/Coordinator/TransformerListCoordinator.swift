//
//  TransformerListCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

struct TransformerListCoordinator {
    static var viewModel: TransformerListViewModel {
        let transformerAPI = TransformerAPIImpl(networkService: NetworkServiceManager.shared.service)
        return TransformerListViewModelImpl(transformerAPI: transformerAPI)
    }
}
