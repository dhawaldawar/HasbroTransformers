//
//  File.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

enum Localizations {
    
    enum Titles {
        static let listTransformer = NSLocalizedString("TITLE_LIST_TRANSFORMER", bundle: .main, value: "Transformers", comment: "Navigation title text where all the list of transformers is displayed.")
    }
    
    enum Messages {
        static let networkErrorTimeout = NSLocalizedString("MESSAGE_NETWORK_ERROR_TIME_OUT", bundle: .main, value: "The request has been timed out, please try again.", comment: "Network error message when request has been timed out.")
        
        static let networkErrorAuthorization = NSLocalizedString("MESSAGE_NETWORK_ERROR_AUTHORIZATION", bundle: .main, value: "We could not authorize your request, please try again.", comment: "Network error message when request has been failed because of authorization.")
        
        static let networkErrorUnexpected = NSLocalizedString("MESSAGE_NETWORK_ERROR_UNEXPECTED", bundle: .main, value: "We could not complete your request, please try again.", comment: "Network error message when request has been failed because of authorization.")
        
        static let transformersListUnavailable = NSLocalizedString("MESSAGE_TRANSFORMERS_LIST_UNAVAILABLE", bundle: .main, value: "No transformer is available.", comment: "Information to the user when no transformers received from cloud.")
        
        static let transformersListIsLoading = NSLocalizedString("MESSAGE_TRANSFORMERS_LIST_LOADING", bundle: .main, value: "Fetching list of available transformers", comment: "Information to the user while fetching list of transformers from cloud.")
    }
    
}
