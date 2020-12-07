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

protocol TransformerListViewModel {
    
    /// To observe loading status.
    var loadingStatus: Observable<LoadingStatus> { get }

    /// All the available transformer's view model.
    var transformersViewModel: BehaviorRelay<[TransformerListCellViewModel]> { get }

    /// Requests to load all the available transformers.
    func loadTransformers()
}

class TransformerListViewModelImpl: TransformerListViewModel {
    var loadingStatus: Observable<LoadingStatus> { _loadingStatus.asObservable() }
    let transformersViewModel = BehaviorRelay(value: [TransformerListCellViewModel]())
    
    private let _loadingStatus = BehaviorRelay<LoadingStatus>(value: .loaded)
    private let transformerAPI: TransformerAPI
    
    init(transformerAPI: TransformerAPI) {
        self.transformerAPI = transformerAPI
        loadTransformers()
    }
    
    func loadTransformers() {
        if case LoadingStatus.loading = _loadingStatus.value {
            Log.assertionFailure("Transformers list is already being fetched")
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
    
    //MARK:- Private
    private func received(transformers: [Transformer]) {
        guard transformers.count != 0 else {
            _loadingStatus.accept(.info(message: Localizations.Messages.transformersListUnavailable))
            return
        }

        let cellViewModels: [TransformerListCellViewModel] = transformers.map(TransformerListCellViewModelImpl.init)
        transformersViewModel.accept(cellViewModels)
        _loadingStatus.accept(LoadingStatus.loaded)
    }
}
