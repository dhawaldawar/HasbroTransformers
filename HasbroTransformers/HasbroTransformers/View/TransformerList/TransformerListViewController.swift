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
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    var viewModel: TransformerListViewModel!
    var selectedUpdateViewModel: TransformerUpdateViewModel?
    
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
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
        case Constants.updateSequeIdentifier:
            guard let viewController = segue.destination as? TransformerUpdateViewController else {
                Log.assertionFailure("Destination controller is not of type `TransformerUpdateViewController`.")
                return
            }
            
            if let selectedUpdateViewModel = selectedUpdateViewModel {
                viewController.viewModel = selectedUpdateViewModel
            } else {
                viewController.viewModel = viewModel.getViewModelToCreateTransformer()
            }
        default: break
        }
    }
    
    //MARK: Private
    private func setupBindings() {
        guard let loadingStatus = loadingViewController?.loadingStatus else {
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
        cell.viewModel = viewModel.cellViewModel(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUpdateViewModel = viewModel.getViewModelToUpdateTransformer(index: indexPath.row)
        performSegue(withIdentifier: Constants.updateSequeIdentifier, sender: nil)
    }

}
