//
//  TransformerListCellViewModel.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import RxSwift

protocol TransformerListCellViewModel {
    var strength: Int { get }
    var intelligence: Int { get }
    var speed: Int { get }
    var endurance: Int { get }
    var rank: Int { get }
    var courage: Int { get }
    var firepower: Int { get }
    var skill: Int { get }
    var overallRating: Int { get }
    var team: String { get }
    var name: String { get }
    var teamIconURL: URL? { get }
}

class TransformerListCellViewModelImpl: TransformerListCellViewModel {
    
    var strength: Int { transformer.strength }
    
    var intelligence: Int { transformer.intelligence }
    
    var speed: Int { transformer.speed }
    
    var endurance: Int { transformer.endurance }
    
    var rank: Int { transformer.rank }
    
    var courage: Int { transformer.courage }
    
    var firepower: Int { transformer.firepower }
    
    var skill: Int { transformer.skill }
    
    var overallRating: Int { transformer.overallRating }
    
    var team: String { transformer.team.string }
    
    var name: String { transformer.name }
    
    var teamIconURL: URL? { transformer.teamIcon }

    private let transformer: Transformer

    init(transformer: Transformer) {
        self.transformer = transformer
    }
}
