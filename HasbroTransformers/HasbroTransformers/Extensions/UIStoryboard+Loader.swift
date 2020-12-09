//
//  UIStoryboard+Loader.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit

fileprivate enum Storyboard : String {
    case main = "Main"
}

fileprivate extension UIStoryboard {
    
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }

    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: App View Controllers
extension UIStoryboard {
    static func loadLoadingViewController() -> LoadingViewController {
        return loadFromMain("LoadingViewController") as! LoadingViewController
    }
    
    static func loadTransformerListViewController() -> TransformerListViewController {
        return loadFromMain("TransformerListViewController") as! TransformerListViewController
    }
}
