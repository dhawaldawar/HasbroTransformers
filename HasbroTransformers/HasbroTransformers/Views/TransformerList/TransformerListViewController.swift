//
//  ViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 05/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class TransformerListViewController: BaseViewController {

    private enum Constants {
        static let listCellIdentifier = "ListCell"
        static let updateSequeIdentifier = "UpdateSegue"
        static let battleSequeIdentifier = "BattleSegue"
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    var viewModel: TransformerListViewModel!
    
    private var selectedUpdateViewModel: TransformerUpdateViewModel?
    private let disposeBag = DisposeBag()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localizations.Titles.listTransformer
        addLoadingView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadTransformers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        // To create/update/delete transformer.
        case Constants.updateSequeIdentifier:
            guard let viewController = segue.destination as? TransformerUpdateViewController else {
                Log.assertionFailure("Destination controller is not of type `TransformerUpdateViewController`.")
                return
            }
            
            /// To determine if user has selected any transformer to see the details.
            if let selectedUpdateViewModel = selectedUpdateViewModel {
                viewController.viewModel = selectedUpdateViewModel
                self.selectedUpdateViewModel = nil
            } else {
                viewController.viewModel = viewModel.getViewModelToCreateTransformer()
            }
        
        // To perform battles amoung existing transformers.
        case Constants.battleSequeIdentifier:
            guard let viewController = segue.destination as? BattleViewController else {
                Log.assertionFailure("Destination controller is not of type `BattleViewController`.")
                return
            }
            viewController.viewModel = viewModel.getViewModelToShowBattle()

        default: break
        }
    }
    
    //MARK:- Private
    private func setupBindings() {
        guard let loadingStatus = loadingViewController?.loadingStatus else {
            Log.assertionFailure("`LoadingViewController` is unavailable.")
            return
        }

        viewModel.loadingStatus.bind(to: loadingStatus).disposed(by: disposeBag)
        
        loadingViewController?.tryAgainButtonTapped.subscribe(onNext: { [weak self] in
            self?.viewModel.loadTransformers()
        }).disposed(by: disposeBag)
        
        viewModel.numberOfTransformers.subscribe(onNext: { [weak self] _ in
            self?.listTableView.reloadData()
        }).disposed(by: disposeBag)
    }

}

extension TransformerListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTransformers.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listCellIdentifier) as! TransformerListCellView
        cell.viewModel = viewModel.getCellViewModel(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUpdateViewModel = viewModel.getViewModelToUpdateTransformer(index: indexPath.row)
        performSegue(withIdentifier: Constants.updateSequeIdentifier, sender: nil)
    }

}
