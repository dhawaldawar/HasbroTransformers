//
//  LoadingViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

enum LoadingStatus {
    case loading(message: String)
    case loaded
    case info(message: String)
    case failed(message: String)
}

class LoadingViewController: UIViewController {
    
    let loadingStatus = BehaviorRelay(value: LoadingStatus.loaded)
    lazy var tryAgainButtonTapped: Observable<Void> = tryAgainButton.rx.tap.asObservable()
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    //MARK: Private
    private func setupBindings() {
        loadingStatus.subscribe(onNext: { [weak self] status in
            switch status {
            case .loading(let message):
                self?.showLoading(message: message)
                
            case .failed(let message):
                self?.showError(message: message)
            
            case .info(let message):
                self?.showInfo(message: message)
                
            case .loaded:
                self?.view.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        
    }
    
    private func showLoading(message: String) {
        tryAgainButton.isHidden = true
        activityIndicator.isHidden = false
        view.isHidden = false

        messageLabel.text = message
    }
    
    private func showError(message: String) {
        activityIndicator.isHidden = true
        tryAgainButton.isHidden = false
        view.isHidden = false
        
        messageLabel.text = message
    }
    
    private func showInfo(message: String) {
        activityIndicator.isHidden = true
        tryAgainButton.isHidden = false
        view.isHidden = false
        
        messageLabel.text = message
    }
    
    
}
