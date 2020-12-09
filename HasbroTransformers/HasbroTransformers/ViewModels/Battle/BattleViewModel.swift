//
//  BattleViewModel.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

/// ViewModel to handle all the activities to perform battle between Autobots and Decepticons team
protocol BattleViewModel {
    
    /// Number of planned battles
    var numberOfPlannedBattles: Int { get }
    
    /// Number of survivors
    var numberOfSurvivors: Int { get }
    
    /// Total battles which have been performed.
    var totalPerformedBattles: String { get }
    
    /// Description of final result of the battles.
    var finalResultDescription: String { get }
    
    var autobotsTeam: Transformer.Team { get }
    var decepticonsTeam: Transformer.Team { get }

    func getAutobotsBattleCellViewModel(at index: Int) -> BattleCellViewModel
    func getDecepticonsBattleCellViewModel(at index: Int) -> BattleCellViewModel
    func getAutobotsSurvivorBattleCellViewModel(at index: Int) -> BattleCellViewModel?
    func getDecepticonsSurvivorBattleCellViewModel(at index: Int) -> BattleCellViewModel?
}

fileprivate struct Battle {
    
    struct TeamInfo {
        let transformer: Transformer
        let result: Transformer.BattleResult
    }
    
    let autobots: TeamInfo
    let decepticons: TeamInfo
    
    var isDestroyed: Bool {
        // Can check any team result to determine if the battle is destroyed.
        return autobots.result == .destroyed
    }
}

fileprivate struct Survivor {
    let autobotsTransformer: Transformer?
    let decepticonsTransformer: Transformer?
    
    init(autobotsTransformer: Transformer) {
        self.autobotsTransformer = autobotsTransformer
        decepticonsTransformer = nil
    }
    
    init(decepticonsTransformer: Transformer) {
        autobotsTransformer = nil
        self.decepticonsTransformer = decepticonsTransformer
    }
}

class BattleViewModelImpl: BattleViewModel {
    struct FinalResult {
        var totalPerformedBattles = 0
        var autobotsWonBattles = 0
        var decepticonsWonBattles = 0
        var isGameDestroyed = false
    }

    var totalPerformedBattles: String {
        "\(finalResult.totalPerformedBattles) \(finalResult.totalPerformedBattles == 1 ? "Battle" : "Battles")"
    }
    
    var finalResultDescription: String {
        if finalResult.isGameDestroyed {
            return "Game ended abruptly and all the remaining competitors have been destroyed."
        } else if finalResult.autobotsWonBattles > finalResult.decepticonsWonBattles {
            return "Winning team: Autobots, Won \(finalResult.autobotsWonBattles) \(finalResult.autobotsWonBattles == 1 ? "battle" : "battles")"
        } else if finalResult.decepticonsWonBattles > finalResult.autobotsWonBattles {
            return "Winning team: Decepticons, Won \(finalResult.decepticonsWonBattles) \(finalResult.decepticonsWonBattles == 1 ? "battle" : "battles")"
        } else {
            return "It's a tie."
        }
    }
    
    var numberOfPlannedBattles: Int { battles.count }
    var numberOfSurvivors: Int { survivors.count }
    
    let autobotsTeam = Transformer.Team.autobot
    let decepticonsTeam = Transformer.Team.decepticon

    private var battles = [Battle]()
    private var survivors = [Survivor]()
    private var finalResult = FinalResult()
    
    init(transformers: [Transformer]) {
        let autobotsTransformers = transformers
                                        .filter { $0.team == autobotsTeam }
                                        .sorted { $0.rank > $1.rank }
        
        let decepticonsTransformers = transformers
                                        .filter { $0.team == decepticonsTeam }
                                        .sorted { $0.rank > $1.rank }
        
        prepareBattles(autobotsTransformers: autobotsTransformers, decepticonsTransformers: decepticonsTransformers)
        prepareSurvivors(autobotsTransformers: autobotsTransformers, decepticonsTransformers: decepticonsTransformers)
        prepareFinalResultDetails()
    }
    
    func getAutobotsBattleCellViewModel(at index: Int) -> BattleCellViewModel {
        let battle = battles[index]
        let result = battle.autobots.result == .tie ? .destroyed : battle.autobots.result
        return BattleCellViewModelImpl(
            transformer: battle.autobots.transformer,
            result: result.rawValue,
            backgroundColor: UIColor.autobotsThemeColor,
            resultBackgroundColor: backgrounColor(for: result)
        )
    }
    
    func getDecepticonsBattleCellViewModel(at index: Int) -> BattleCellViewModel {
        let battle = battles[index]
        let result = battle.decepticons.result == .tie ? .destroyed : battle.decepticons.result
        return BattleCellViewModelImpl(
            transformer: battle.decepticons.transformer,
            result: result.rawValue,
            backgroundColor: UIColor.decepticonsThemeColor,
            resultBackgroundColor: backgrounColor(for: result))
    }
    
    func getAutobotsSurvivorBattleCellViewModel(at index: Int) -> BattleCellViewModel? {
        let survivor = survivors[index]
        guard let transformer = survivor.autobotsTransformer else {
            return nil
        }
        
        return BattleCellViewModelImpl(
        transformer: transformer,
        result: Localizations.Text.survivor,
        backgroundColor: UIColor.autobotsThemeColor,
        resultBackgroundColor: UIColor.survivorBattleBackground)
    }
    
    func getDecepticonsSurvivorBattleCellViewModel(at index: Int) -> BattleCellViewModel? {
        let survivor = survivors[index]
        guard let transformer = survivor.decepticonsTransformer else {
            return nil
        }
        
        return BattleCellViewModelImpl(
        transformer: transformer,
        result: Localizations.Text.survivor,
        backgroundColor: UIColor.decepticonsThemeColor,
        resultBackgroundColor: UIColor.survivorBattleBackground)
    }
    
    //Mark: Private
    func prepareBattles(autobotsTransformers: [Transformer], decepticonsTransformers: [Transformer]) {
        var isGameDestroyed = false
        battles = zip(autobotsTransformers, decepticonsTransformers).map {
            let autobotsBattleResult: Transformer.BattleResult
            let decepticonsBattleResult: Transformer.BattleResult
            
            if isGameDestroyed {
                autobotsBattleResult = .destroyed
                decepticonsBattleResult = .destroyed
            } else {
                autobotsBattleResult = $0.battle(with: $1)
                decepticonsBattleResult = $1.battle(with: $0)
                
                // If anyone is destroyed another one too, which means game is ended with all the competitors destroyed.
                if autobotsBattleResult == .destroyed {
                    isGameDestroyed = true
                }
            }
            
            let autobotsInfo = Battle.TeamInfo(transformer: $0, result: autobotsBattleResult)
            let decepticonsInfo = Battle.TeamInfo(transformer: $1, result: decepticonsBattleResult)
            return Battle(autobots: autobotsInfo, decepticons: decepticonsInfo)
        }
    }
    
    func prepareSurvivors(autobotsTransformers: [Transformer], decepticonsTransformers: [Transformer]) {
        survivors = {
            // Check if there are no survivors.
            guard autobotsTransformers.count != decepticonsTransformers.count else {
                return [Survivor]()
            }
            
            // Which team has survivors.
            if autobotsTransformers.count > decepticonsTransformers.count {
                return stride(from: battles.count, to: autobotsTransformers.count, by: 1).map {
                    Survivor(autobotsTransformer: autobotsTransformers[$0])
                }
            } else {
                return stride(from: battles.count, to: decepticonsTransformers.count, by: 1).map {
                    Survivor(decepticonsTransformer: decepticonsTransformers[$0])
                }
            }
        }()
    }

    func prepareFinalResultDetails() {
        finalResult = battles.reduce(FinalResult(), { result, battle -> FinalResult in
            guard !result.isGameDestroyed else {
                return result
            }
            var result = result
            result.totalPerformedBattles += 1
            result.autobotsWonBattles += battle.autobots.result == .won ? 1 : 0
            result.decepticonsWonBattles += battle.decepticons.result == .won ? 1 : 0
            if battle.isDestroyed {
                result.isGameDestroyed = true
            }
            return result
        })
    }

    func backgrounColor(for battleResult: Transformer.BattleResult) -> UIColor {
        switch battleResult {
        case .won:
            return UIColor.wonBattleBackground
            
        case .lost:
            return UIColor.lostBattleBackground
            
        case .destroyed:
            return UIColor.destroyedBattleBackground
            
        case .tie:
            return UIColor.destroyedBattleBackground
        }
    }
    
}
