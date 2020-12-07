//
//  NetworkServiceManager.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

/// Responsible to manage the instance of network service that would be used in the production APP.
class NetworkServiceManager {
    static let shared = NetworkServiceManager()
    let service: NetworkService = NetworkServiceImpl(urlSession: URLSession.shared)
}
