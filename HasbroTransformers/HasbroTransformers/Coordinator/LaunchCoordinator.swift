//
//  LaunchCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

struct LaunchCoordinator {

    static var rootViewController: UIViewController {
        let listViewController = UIStoryboard.loadTransformerListViewController()
        listViewController.viewModel = TransformerListCoordinator.viewModel
        return UINavigationController(rootViewController: listViewController)
    }
    
}
