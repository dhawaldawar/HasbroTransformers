//
//  BattleCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 09/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

/// Factory cordinator to create objects required to perform battles.
struct BattleCoordinator {
    
    static func viewModel(transformers: [Transformer]) -> BattleViewModel {
        return BattleViewModelImpl(transformers: transformers)
    }

}
