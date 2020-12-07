//
//  BaseViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var loadingViewController: LoadingViewController?
    
    func addLoadingView() {
        guard loadingViewController == nil else {
            Log.assertionFailure("Loading view controller has already been added.")
            return
        }
        let loadingViewController = UIStoryboard.loadLoadingViewController()
        self.loadingViewController = loadingViewController
        insertChildController(loadingViewController)
    }

}
