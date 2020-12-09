//
//  UIViewController+Subview.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func insertChildController(_ childController: UIViewController) {
        childController.willMove(toParent: self)
        self.addChild(childController)
        childController.didMove(toParent: self)
        
        guard let childView = childController.view else {
            return
        }

        self.view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = true
        childView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        childView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
}

