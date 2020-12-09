//
//  Transformer+Battle.swift
//  HasbroTransformers
//
//  Created by Dhawal on 09/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

extension Transformer {
    
    enum BattleResult: String {
        case won = "Won"
        case lost = "Lost"
        case destroyed = "Destroyed"
        case tie
    }
    
    enum Constants {
        static let specialNames = ["Optimus Prime", "Predaking"]
    }
    
    /// Performs battle with another `Transformer`
    func battle(with transformer: Transformer) -> BattleResult {
        typealias ruleClouser = (_ : Transformer) -> BattleResult?
        let rules: [ruleClouser] = [
            specialRule(opponent:),
            courageAndStrengthRule(opponent:),
            skillRule(opponent:),
            overallRatingRule(opponent:)
        ]
        
        if let result = rules.reduce(nil, { (currentResult, rule) -> BattleResult? in
            currentResult == nil ? rule(transformer) : currentResult
        }) {
           return result
        } else {
            return .tie
        }
    }
    
    //MARK:- Private
    private func specialRule(opponent transformer: Transformer) -> BattleResult? {
        // Check if both opponents have special name
        if Constants.specialNames.contains(name) && Constants.specialNames.contains(transformer.name) {
            return .destroyed
        } else if Constants.specialNames.contains(name) {
            return .won
        } else if Constants.specialNames.contains(transformer.name) {
            return .lost
        }
        
        return nil
    }
    
    private func courageAndStrengthRule(opponent transformer: Transformer) -> BattleResult? {
        if courage >= transformer.courage + 4 && strength >= transformer.strength + 3 {
            return .won
        } else if transformer.courage >= courage + 4 && transformer.strength >= strength + 3 {
            return .lost
        }

        return nil
    }
    
    private func skillRule(opponent transformer: Transformer) -> BattleResult? {
        if skill >= transformer.skill + 3 {
            return .won
        } else if transformer.skill >= skill + 3 {
            return .lost
        }
        
        return nil
    }
    
    private func overallRatingRule(opponent transformer: Transformer) -> BattleResult? {
        if overallRating > transformer.overallRating {
            return .won
        } else if transformer.overallRating > overallRating {
            return .lost
        }
        
        return nil
    }
}
