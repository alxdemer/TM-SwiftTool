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
    case failedToStoreAdminPassword
    case failedToGetAdminPassword
    case noAdminPasswordStoredInKeychain
    
    var errorDescription: String?{
        switch self{
        case .failedToStoreAdminPassword: return "Failed to store the admin password in keychain."
        case .failedToGetAdminPassword: return "Failed to get admin password from keychain."
        case .noAdminPasswordStoredInKeychain: return "There is no admin password that is currently stored in keychain."
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
