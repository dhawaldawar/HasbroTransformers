//
//  LaunchCoordinator.swift
//  HasbroTransformers
//
//  Created by Dhawal on 08/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

/// Factory conrdinator to create objects required at the launch time.
struct LaunchCoordinator {

    static var rootViewController: UIViewController {
        // Setup navigation appearance
        UINavigationBar.appearance().barTintColor = UIColor.navigationBar
        UINavigationBar.appearance().tintColor = UIColor.navigationTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.navigationTitle]

        let listViewController = UIStoryboard.loadTransformerListViewController()
        listViewController.viewModel = TransformerListCoordinator.viewModel
        return UINavigationController(rootViewController: listViewController)
    }
    
}
