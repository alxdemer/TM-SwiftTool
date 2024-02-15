//
//  Errors.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation

enum InfoRetrievalError: LocalizedError{
    case macModel
    case ramInfo
    case storageInfo
    
    var errorDescription: String?{
        switch self{
        case .macModel: "Failed to get the mac model."
        case .ramInfo: "Failed to get RAM info."
        case .storageInfo: "Failed to get the storage info."
        }
    }
    
}

enum ConversionError: LocalizedError{
    case dataToString
    case cfContainerToData
}

enum AdminPasswordManagerError: LocalizedError{
    case failedToAddItem
    case failedToRetrieveItem
    case failedToExtractAdminPassword
    case failedToDeleteItem
    
    var errorDescription: String?{
        switch self{
        case .failedToAddItem: "Failed to add the item to keychain."
        case .failedToRetrieveItem: "Failed to retrieve an item from keychain using the specified query."
        case .failedToExtractAdminPassword: "Failed to extract the admin password from the keychain item."
        case .failedToDeleteItem: "Failed to delete an item from keychain using the specified query."
        }
    }
}

enum SeniorReviewError: LocalizedError{
    case failedToStartAudioTest(error: Error)
    
    var errorDescription: String?{
        switch self{
        case .failedToStartAudioTest(let error): return "Failed to start audio test. \(error.localizedDescription)"
        }
    }
}
