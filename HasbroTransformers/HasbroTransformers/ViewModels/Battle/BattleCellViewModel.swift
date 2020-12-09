//
//  BattleCellViewModel.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

protocol BattleCellViewModel {
    var strength: Int { get }
    var intelligence: Int { get }
    var speed: Int { get }
    var endurance: Int { get }
    var rank: Int { get }
    var courage: Int { get }
    var firepower: Int { get }
    var skill: Int { get }
    var overallRating: Int { get }
    var name: String { get }

    var result: String { get }
    var backgroundColor: UIColor { get }
    var resultBackgroundColor: UIColor { get }
}

class BattleCellViewModelImpl: BattleCellViewModel {
    var strength: Int { transformer.strength }
    
    var intelligence: Int { transformer.intelligence }
    
    var speed: Int { transformer.speed }
    
    var endurance: Int { transformer.endurance }
    
    var rank: Int { transformer.rank }
    
    var courage: Int { transformer.courage }
    
    var firepower: Int { transformer.firepower }
    
    var skill: Int { transformer.skill }
    
    var overallRating: Int { transformer.overallRating }

    var name: String { transformer.name }
    
    var result: String
    
    var backgroundColor: UIColor
    
    var resultBackgroundColor: UIColor
    
    private let transformer: Transformer
    
    init(transformer: Transformer, result: String, backgroundColor: UIColor, resultBackgroundColor: UIColor) {
        self.transformer = transformer
        self.result = result
        self.backgroundColor = backgroundColor
        self.resultBackgroundColor = resultBackgroundColor
    }
    
}
