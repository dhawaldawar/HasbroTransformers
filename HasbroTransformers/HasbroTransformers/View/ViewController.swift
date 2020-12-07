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

    @IBOutlet weak var listTableView: UITableView!
    var viewModel: TransformerListViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadingView()
    }
    
    func setupBindings() {
        guard let loadingStatus = loadingViewController?.loadingStatus else {
            return
        }
        viewModel.loadingStatus.bind(to: loadingStatus).disposed(by: disposeBag)
        
    }

}

