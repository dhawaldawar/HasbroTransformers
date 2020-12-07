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
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    var viewModel: TransformerListViewModel!
    
    private let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localizations.Titles.listTransformer
        addLoadingView()
        setupBindings()
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
        
        viewModel.transformersViewModel.subscribe(onNext: { [weak self] _ in
            self?.listTableView.reloadData()
        }).disposed(by: disposeBag)
    }

}

extension TransformerListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transformersViewModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listCellIdentifier) as! TransformerListCellView
        cell.viewModel = viewModel.transformersViewModel.value[indexPath.row]
        return cell
    }

}
