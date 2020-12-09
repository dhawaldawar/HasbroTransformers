//
//  TransformerUpdateViewModel.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

enum TransformerUpdateCompletionStatus {
    case success
    case failure(message: String)
}

/// ViewModel that handles all the activites to create/update/detail transformers.
protocol TransformerUpdateViewModel {

    /// Name of the transformer.
    var name: BehaviorRelay<String> { get }
    
    /// Transformer's team
    var team: BehaviorRelay<Transformer.Team> { get }
    
    // Transformer's stats.
    var strength: BehaviorRelay<Int> { get }
    var speed: BehaviorRelay<Int> { get }
    var rank: BehaviorRelay<Int> { get }
    var firepower: BehaviorRelay<Int> { get }
    var intelligence: BehaviorRelay<Int> { get }
    var endurance: BehaviorRelay<Int> { get }
    var courage: BehaviorRelay<Int> { get }
    var skill: BehaviorRelay<Int> { get }
    var overallRating: Observable<Int> { get }
    
    /// Determine in which mode view model is being operated.
    var isUpdateMode: Observable<Bool> { get }
    
    /// Compeletion when the operation has been completed.
    var completion: Observable<TransformerUpdateCompletionStatus> { get }

    /// To observe loading status.
    var loadingStatus: Observable<LoadingStatus> { get }

    /// Creates new transformer.
    func create()
    
    /// Edits existing transformer.
    func edit()
    
    /// Deletes existing transformer.
    func delete()
}

class TransformerUpdateViewModelImpl: TransformerUpdateViewModel {
    let strength = BehaviorRelay(value: 1)
    let speed = BehaviorRelay(value: 1)
    let rank = BehaviorRelay(value: 1)
    let firepower = BehaviorRelay(value: 1)
    let intelligence = BehaviorRelay(value: 1)
    let endurance = BehaviorRelay(value: 1)
    let courage = BehaviorRelay(value: 1)
    let skill = BehaviorRelay(value: 1)

    let name = BehaviorRelay(value: "")
    let team = BehaviorRelay(value: Transformer.Team.autobot)
    
    var overallRating: Observable<Int> { _overallRating.asObservable() }
    var completion: Observable<TransformerUpdateCompletionStatus> { _completionStatus.asObservable() }
    var isUpdateMode: Observable<Bool> { _isUpdateMode.asObservable() }
    var loadingStatus: Observable<LoadingStatus> { _loadingStatus.asObservable() }

    private let _overallRating = BehaviorRelay(value: 1)
    private let _completionStatus = PublishRelay<TransformerUpdateCompletionStatus>()
    private let _isUpdateMode = BehaviorRelay(value: false)
    private let _loadingStatus = BehaviorRelay<LoadingStatus>(value: .loaded)
    
    private let transformerAPI: TransformerAPI
    private let transformer: Transformer?
    private var disposebag = DisposeBag()
    
    init(transformer: Transformer?, transformerAPI: TransformerAPI) {
        self.transformer = transformer
        self.transformerAPI = transformerAPI
        _isUpdateMode.accept(transformer != nil)
        setupBindings()
        
        if let transformer = transformer {
            setupDetails(transformer: transformer)
        }
    }
    
    func create() {
        guard transformer == nil else {
            Log.assertionFailure("`Create` operation is not expected as `Transformer` object is available.")
            return
        }

        guard !name.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            _completionStatus.accept(.failure(message: Localizations.Messages.transformerNameEmpty))
            return
        }
        
        let transformer = Transformer(
            name: name.value,
            team: team.value,
            strength: strength.value,
            intelligence: intelligence.value,
            speed: speed.value,
            endurance: endurance.value,
            rank: rank.value,
            courage: courage.value,
            firepower: firepower.value,
            skill: skill.value
        )
        performOperation(transformer: transformer, loadingMessage: Localizations.Messages.creatingTransformer, operation: transformerAPI.create)
    }
    
    func edit() {
        guard let transformer = transformer else {
            Log.assertionFailure("`Transformer` object is unavailable to update.")
            return
        }
        let editedTransformer = Transformer(
            id: transformer.id,
            name: name.value,
            team: team.value,
            strength: strength.value,
            intelligence: intelligence.value,
            speed: speed.value,
            endurance: endurance.value,
            rank: rank.value,
            courage: courage.value,
            firepower: firepower.value,
            skill: skill.value
        )
        performOperation(transformer: editedTransformer, loadingMessage: Localizations.Messages.updatingTransformer, operation: transformerAPI.update)
    }
    
    func delete() {
        guard let transformer = transformer else {
            Log.assertionFailure("`Transformer` object is unavailable to delete.")
            return
        }

        performOperation(transformer: transformer, loadingMessage: Localizations.Messages.deletingTransformer, operation: transformerAPI.delete)
    }
    
    //MARK:- Private
    private func setupDetails(transformer: Transformer) {
        name.accept(transformer.name)
        team.accept(transformer.team)
        strength.accept(transformer.strength)
        intelligence.accept(transformer.intelligence)
        speed.accept(transformer.speed)
        endurance.accept(transformer.endurance)
        rank.accept(transformer.rank)
        courage.accept(transformer.courage)
        firepower.accept(transformer.firepower)
        skill.accept(transformer.skill)
    }

    private func setupBindings() {
        Observable.combineLatest(strength, intelligence, speed, endurance, firepower).map { strength, intelligence, speed, endurance, firepower in
            return strength + intelligence + speed + endurance + firepower
        }.bind(to: _overallRating).disposed(by: disposebag)
    }
    
    private func performOperation(
        transformer: Transformer,
        loadingMessage: String,
        operation: (Transformer, _ completion: @escaping (Result<Void, NetworkError>) -> Void) -> Void
    ) {
        guard !name.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            _completionStatus.accept(.failure(message: Localizations.Messages.transformerNameEmpty))
            return
        }
        
        _loadingStatus.accept(.loading(message: loadingMessage))
        
        operation(transformer) { [weak self] result in
            self?._loadingStatus.accept(.loaded)
            switch result {
            case .success:
                self?._completionStatus.accept(.success)

            case .failure(let error):
                self?._completionStatus.accept(.failure(message: error.localizedDescription))
            }
        }
    }
    
    
}
