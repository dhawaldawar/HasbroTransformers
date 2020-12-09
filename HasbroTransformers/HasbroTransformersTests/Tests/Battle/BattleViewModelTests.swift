//
//  BattleViewModelTests.swift
//  HasbroTransformersTests
//
//  Created by Dhawal on 09/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import XCTest
@testable import HasbroTransformers

class BattleViewModelTests: XCTestCase {
    
    func testOneBattleWhereAutobotsTeamWin() {
        let autobotsTransformer = Transformer(name: "Soundwave", team: .autobot, strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10)
        let decepticonsTransformer = Transformer(name: "Bluestreak", team: .decepticon, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 1, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 0, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "1 Battle", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "Winning team: Autobots, Won 1 battle", "Final result description does not match.")
    }
    
    func testTwoBattleWhereDecepticonsTeamWinByTwoBattles() {
        let autobotsTransformer = Transformer(name: "Soundwave", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10)
        
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer, autobotsTransformer, decepticonsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 2, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 0, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "2 Battles", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "Winning team: Decepticons, Won 2 battles", "Final result description does not match.")
    }
    
    func testOneBattlesWhereOneSurvivor() {
        let autobotsTransformer = Transformer(name: "Soundwave", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10)
        
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer, autobotsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 1, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 1, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "1 Battle", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "Winning team: Decepticons, Won 1 battle", "Final result description does not match.")
    }
    
    func testTwoBattlesWhereTwoSurvivor() {
        let autobotsTransformer = Transformer(name: "Soundwave", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 10, intelligence: 10, speed: 10, endurance: 10, rank: 10, courage: 10, firepower: 10, skill: 10)
        
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer, autobotsTransformer, decepticonsTransformer, decepticonsTransformer, decepticonsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 2, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 2, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "2 Battles", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "Winning team: Decepticons, Won 2 battles", "Final result description does not match.")
    }
    
    func testOneBattlesWhereFinalResultIsTie() {
        let autobotsTransformer = Transformer(name: "Bluestreak", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1)
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 1, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 0, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "1 Battle", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "It's a tie.", "Final result description does not match.")
    }
    
    func testsGameGetDestroyedDuringBattleOfSpecialTransformers() {
        let autobotsTransformer = Transformer(name: "Bluestreak", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 10, courage: 1, firepower: 1, skill: 1)
        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 10, courage: 1, firepower: 1, skill: 1)
        
        let specialAutobotsTransformer = Transformer(name: "Optimus Prime", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 8, courage: 1, firepower: 1, skill: 1)
        let specialDecepticonsTransformer = Transformer(name: "Predaking", team: .decepticon, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 8, courage: 1, firepower: 1, skill: 1)
        
        let secondAutobotsTransformer = Transformer(name: "Bluestreak", team: .autobot, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 7, courage: 1, firepower: 1, skill: 1)
        let secondDecepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 7, courage: 1, firepower: 1, skill: 1)
        
        let viewModel = BattleViewModelImpl(transformers: [autobotsTransformer, decepticonsTransformer, specialAutobotsTransformer, specialDecepticonsTransformer, secondAutobotsTransformer, secondDecepticonsTransformer])
        
        XCTAssertEqual(viewModel.numberOfBattles, 3, "Number of battles does not match.")
        XCTAssertEqual(viewModel.numberOfSurvivours, 0, "Number of survivors does not match.")
        XCTAssertEqual(viewModel.totalPerformedBattles, "2 Battles", "Total performed battles does not match.")
        XCTAssertEqual(viewModel.finalResultDescription, "Game ended abruptly and all the remaining competitors have been destroyed.", "Final result description does not match.")
    }
    
    func testTransformerDetailViewModels() {
        let autobotsTransformer = Transformer(name: "Autobots-1", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 4, rank: 10, courage: 6, firepower: 7, skill: 8)
        let secondAutobotsTransformer = Transformer(name: "Autobots-2", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 5, rank: 5, courage: 5, firepower: 6, skill: 7)
        let survivorAutobotsTransformer = Transformer(name: "Autobots-2", team: .autobot, strength: 1, intelligence: 2, speed: 3, endurance: 5, rank: 3, courage: 5, firepower: 6, skill: 7)

        let decepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 3, intelligence: 10, speed: 9, endurance: 8, rank: 9, courage: 6, firepower: 5, skill: 4)
        
        let secondDecepticonsTransformer = Transformer(name: "Soundwave", team: .decepticon, strength: 1, intelligence: 8, speed: 4, endurance: 6, rank: 4, courage: 6, firepower: 7, skill: 9)
        
        let expectedAutobotsBattleTransformers = [autobotsTransformer, secondAutobotsTransformer]
        let expectedDecepticonsBattleTransformers = [decepticonsTransformer, secondDecepticonsTransformer]
        let expectedSurvivorTransformers = [survivorAutobotsTransformer]
        
        let viewModel = BattleViewModelImpl(transformers: expectedAutobotsBattleTransformers + expectedDecepticonsBattleTransformers + expectedSurvivorTransformers)
        
        // Verify Autobots transformer details who participated in the battle
        (0..<expectedAutobotsBattleTransformers.count).forEach {
            print(viewModel.getAutobotsBattleCellViewModel(at: $0).rank)
            print(expectedAutobotsBattleTransformers[$0].rank)
            assert(transformer: expectedAutobotsBattleTransformers[$0],
                viewModel: viewModel.getAutobotsBattleCellViewModel(at: $0))
        }
        
        // Verify Decepticons transformer details who participated in the battle
        (0..<expectedDecepticonsBattleTransformers.count).forEach {
            assert(transformer: expectedDecepticonsBattleTransformers[$0],
                viewModel: viewModel.getDecepticonsBattleCellViewModel(at: $0))
        }
        
        // Verify autobots survivor transformer details
        (0..<expectedSurvivorTransformers.count).forEach {
            guard let viewModel = viewModel.getAutobotsSurvivorBattleCellViewModel(at: 0) else {
                XCTFail("ViewModel is unavailable.")
                return
            }
            assert(transformer: expectedSurvivorTransformers[$0], viewModel: viewModel)
        }
        
        // Verify there is no survivor in Decepticon's team.
        XCTAssertNil(viewModel.getDecepticonsSurvivorBattleCellViewModel(at: 0), "Survivor is not expected in Decepticon's team.")
    }
    
    private func assert(transformer: Transformer, viewModel: BattleCellViewModel) {
        XCTAssertEqual(transformer.strength, viewModel.strength, "Strength does not match.")
        XCTAssertEqual(transformer.intelligence, viewModel.intelligence, "Intelligence does not match.")
        XCTAssertEqual(transformer.speed, viewModel.speed, "Speed does not match.")
        XCTAssertEqual(transformer.endurance, viewModel.endurance, "Endurance does not match.")
        XCTAssertEqual(transformer.rank, viewModel.rank, "Rank does not match.")
        XCTAssertEqual(transformer.courage, viewModel.courage, "Courage does not match.")
        XCTAssertEqual(transformer.firepower, viewModel.firepower, "Firepower does not match.")
        XCTAssertEqual(transformer.skill, viewModel.skill, "Skill does not match.")
        XCTAssertEqual(transformer.name, viewModel.name, "Name does not match.")
        XCTAssertEqual(transformer.overallRating, viewModel.overallRating, "Overall rating does not match.")
    }
    
}
