//
//  TransformerListViewModel.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

/// ViewModel that handles all the activites to list transformers details.
protocol TransformerListViewModel {
    
    /// To observe loading status.
    var loadingStatus: Observable<LoadingStatus> { get }

    /// Count of available transformers.
    var numberOfTransformers: BehaviorRelay<Int> { get }

    /// Requests to load all the available transformers.
    func loadTransformers()
    
    /// Returns cell view model at given index.
    func getCellViewModel(at index: Int) -> TransformerListCellViewModel
    
    /// Returns view model to create new transformer.
    func getViewModelToCreateTransformer() -> TransformerUpdateViewModel
    
    /// Returns view model to edit/delete existing transformer.
    func getViewModelToUpdateTransformer(index: Int) -> TransformerUpdateViewModel

    /// Returns view model to show battle of existing transformers.
    func getViewModelToShowBattle() -> BattleViewModel
}

class TransformerListViewModelImpl: TransformerListViewModel {
    var loadingStatus: Observable<LoadingStatus> { _loadingStatus.asObservable() }
    let numberOfTransformers = BehaviorRelay(value: 0)
    
    private let _loadingStatus = BehaviorRelay<LoadingStatus>(value: .loaded)
    private let transformerAPI: TransformerAPI
    private var transformers = [Transformer]()
    
    init(transformerAPI: TransformerAPI) {
        self.transformerAPI = transformerAPI
    }
    
    func loadTransformers() {
        if case LoadingStatus.loading = _loadingStatus.value {
            return
        }

        _loadingStatus.accept(.loading(message: Localizations.Messages.transformersListIsLoading))
        transformerAPI.fetchAllTransformers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let transformers):
                strongSelf.received(transformers: transformers)

            case .failure(let error):
                strongSelf._loadingStatus.accept(.failed(message: error.localizedDescription))
            }
        }
    }
    
    func getCellViewModel(at index: Int) -> TransformerListCellViewModel {
        TransformerListCellViewModelImpl(transformer: transformers[index])
    }
    
    func getViewModelToCreateTransformer() -> TransformerUpdateViewModel {
        TransformerUpdateCoordinator.viewModel(transformer: nil)
    }
    
    func getViewModelToUpdateTransformer(index: Int) -> TransformerUpdateViewModel {
        TransformerUpdateCoordinator.viewModel(transformer: transformers[index])
    }
    
    func getViewModelToShowBattle() -> BattleViewModel {
        BattleCoordinator.viewModel(transformers: transformers)
    }
    
    //MARK:-- Private
    private func received(transformers: [Transformer]) {
        guard transformers.count != 0 else {
            _loadingStatus.accept(.info(message: Localizations.Messages.transformersListUnavailable))
            return
        }

        self.transformers = transformers
        numberOfTransformers.accept(transformers.count)
        _loadingStatus.accept(LoadingStatus.loaded)
    }
}
