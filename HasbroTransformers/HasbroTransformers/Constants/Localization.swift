//
//  File.swift
//  HasbroTransformers
//
//  Created by Dhawal on 07/12/20.
//  Copyright © 2020 Dhawal. All rights reserved.
//

import Foundation

// Constants for localizations being used in the APP as per their categories.
enum Localizations {
    
    enum Titles {
        static let listTransformer = NSLocalizedString("TITLE_LIST_TRANSFORMER", bundle: .main, value: "Transformers", comment: "Navigation title text where all the list of transformers is displayed.")
        static let errorAlert = NSLocalizedString("TITLE_ERROR_ALERT", bundle: .main, value: "Error!", comment: "Alert title to show for errors.")
        
    }
    
    enum Messages {
        static let networkErrorTimeout = NSLocalizedString("MESSAGE_NETWORK_ERROR_TIME_OUT", bundle: .main, value: "The request has been timed out, please try again.", comment: "Network error message when request has been timed out.")
        
        static let networkErrorAuthorization = NSLocalizedString("MESSAGE_NETWORK_ERROR_AUTHORIZATION", bundle: .main, value: "We could not authorize your request, please try again.", comment: "Network error message when request has been failed because of authorization.")
        
        static let networkErrorUnexpected = NSLocalizedString("MESSAGE_NETWORK_ERROR_UNEXPECTED", bundle: .main, value: "We could not complete your request, please try again.", comment: "Network error message when request has been failed because of authorization.")
        
        static let transformersListUnavailable = NSLocalizedString("MESSAGE_TRANSFORMERS_LIST_UNAVAILABLE", bundle: .main, value: "No transformer is available, please create new by tapping on 'Add' button at the top.", comment: "Information to the user when no transformers received from cloud.")
        
        static let transformersListIsLoading = NSLocalizedString("MESSAGE_TRANSFORMERS_LIST_LOADING", bundle: .main, value: "Fetching list of available transformers", comment: "Information to the user while fetching list of transformers from cloud.")
        
        static let transformerNameEmpty = NSLocalizedString("MESSAGE_TRANSFORMERS_NAMR_EMPTY", bundle: .main, value: "Please enter transformer name.", comment: "Validation on transformer name is is not available.")
        
        static let creatingTransformer = NSLocalizedString("MESSAGE_CREATE_TRANSFORMER", bundle: .main, value: "Creating transformer.", comment: "Information to the user while creating a transformer.")
        
        static let updatingTransformer = NSLocalizedString("MESSAGE_EDIT_TRANSFORMER", bundle: .main, value: "Updating transformer details.", comment: "Information to the user while updating transformer's details.")
        
        static let deletingTransformer = NSLocalizedString("MESSAGE_DELETE_TRANSFORMER", bundle: .main, value: "Deleting transformer.", comment: "Information to the user while deleting a transformer.")
    }
    
    enum Text {
        static let survivor = NSLocalizedString("TEXT_SURVIVOR", bundle: .main, value: "Survivor", comment: "Text to indicate result if a transformer is survivor.")
        static let won = NSLocalizedString("TEXT_WON", bundle: .main, value: "Won", comment: "Text to indicate result if transformer has won the fight.")
        static let lost = NSLocalizedString("TEXT_LOST", bundle: .main, value: "Lost", comment: "Text to indicate result if transformer has lost the fight.")
        static let destroyed = NSLocalizedString("TEXT_DESTROYED", bundle: .main, value: "Destroyed", comment: "Text to indicate result if transformer has been destroyed.")
    }
    
}
