//
//  UIImageView+Cache.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImage(url: URL) {
        self.image = nil

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString)  {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url){ data, response, error in
            if error != nil {
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image
                }
            }

        }.resume()
    }
}
