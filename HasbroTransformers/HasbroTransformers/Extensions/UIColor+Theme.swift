//
//  LoadingViewController.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    //MARK: Theme
    static let primaryTextColor = UIColor.black
    static let secondaryTextColor = UIColor.black
    
    //MARK:- Navigation
    static let navigationBar = rgba(0.0, 86.0, 214.0, 1.0)
    static let navigationTintColor = UIColor.white
    static let navigationTitle = UIColor.white
    
    //MARK:- Battle
    static let wonBattleBackground = rgba(52.0, 159.0, 89.0, 1.0)
    static let lostBattleBackground = UIColor.systemRed
    static let destroyedBattleBackground = UIColor.systemGray
    static let survivorBattleBackground = UIColor.systemTeal
    
    static let autobotsThemeColor = rgba(199.0, 59.0, 48.0, 0.1)
    static let decepticonsThemeColor = rgba(0.0, 122.0, 255.0, 0.1)
    
    //MARK:- Utilities
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}


