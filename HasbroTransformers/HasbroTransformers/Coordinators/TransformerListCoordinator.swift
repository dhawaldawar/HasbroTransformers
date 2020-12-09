//
//  TransformerListCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

/// Factory cordinator to create objects required to show transformers list.
struct TransformerListCoordinator {
    
    static var viewModel: TransformerListViewModel {
        let transformerAPI = TransformerAPIImpl(networkService: NetworkServiceManager.shared.service)
        return TransformerListViewModelImpl(transformerAPI: transformerAPI)
    }
}
