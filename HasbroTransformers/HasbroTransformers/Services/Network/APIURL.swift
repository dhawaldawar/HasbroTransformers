//
//  APIURL.swift
//  HasbroTransformers
//
//  Created by Dhawal on 06/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

enum APIURL {
    private static let baseURL = "https://transformers-api.firebaseapp.com/"
    static let transformer: URL! = URL(string: baseURL + "transformers")
    static let authorization: URL! = URL(string: baseURL + "allspark")
}
