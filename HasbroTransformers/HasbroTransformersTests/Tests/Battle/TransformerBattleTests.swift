//
//  TransformerBattleTests.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 09/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import XCTest
@testable import HasbroTransformers

class TransformerBattleTests: XCTestCase {

    func testsSpecialRuleBattle() {
        guard let specialName = Transformer.Constants.specialNames.first else {
            XCTFail("There are no special names available.")
            return
        }

        let specialOpponent = Transformer(
            name: specialName,
            team: .autobot,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        let opponent = Transformer(
            name: "Any name",
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        let secondSpecialOpponent = Transformer(
            name: specialName,
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        // Won case
        XCTAssertEqual(specialOpponent.battle(with: opponent), .won, "Battle does not match.")
        // Loose case
        XCTAssertEqual(opponent.battle(with: specialOpponent), .lost, "Battle does not match.")
        // Destruction case
        XCTAssertEqual(specialOpponent.battle(with: secondSpecialOpponent), .destroyed, "Battle does not match.")
        
    }
    
    func testCourageAndStrengthRule() {
        let wonOpponent = Transformer(
            name: "Name",
            team: .autobot,
            strength: 4,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 5,
            firepower: 1,
            skill: 1
        )
        
        let lostOpponent = Transformer(
            name: "Name",
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        // Won case
        XCTAssertEqual(wonOpponent.battle(with: lostOpponent), .won, "Battle does not match.")
        // Lost case
        XCTAssertEqual(lostOpponent.battle(with: wonOpponent), .lost, "Battle does not match.")
    }
    
    func testSkillRule() {
        let wonOpponent = Transformer(
            name: "Name",
            team: .autobot,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 4
        )
        
        let lostOpponent = Transformer(
            name: "Name",
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        // Won case
        XCTAssertEqual(wonOpponent.battle(with: lostOpponent), .won, "Battle does not match.")
        // Lost case
        XCTAssertEqual(lostOpponent.battle(with: wonOpponent), .lost, "Battle does not match.")
    }
    
    func testOverallRatingRule() {
        let wonOpponent = Transformer(
            name: "Name",
            team: .autobot,
            strength: 5,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        let lostOpponent = Transformer(
            name: "Name",
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        // Won case
        XCTAssertEqual(wonOpponent.battle(with: lostOpponent), .won, "Battle does not match.")
        // Lost case
        XCTAssertEqual(lostOpponent.battle(with: wonOpponent), .lost, "Battle does not match.")
    }

    func testDestructionResult() {
        let firstOpponent = Transformer(
            name: "Name",
            team: .autobot,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        let secondOpponent = Transformer(
            name: "Name",
            team: .decepticon,
            strength: 1,
            intelligence: 1,
            speed: 1,
            endurance: 1,
            rank: 1,
            courage: 1,
            firepower: 1,
            skill: 1
        )
        
        XCTAssertEqual(firstOpponent.battle(with: secondOpponent), .destroyed, "Battle does not match.")
    }

    
}
