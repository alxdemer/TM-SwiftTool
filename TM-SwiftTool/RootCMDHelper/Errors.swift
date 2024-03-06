//
//  Errors.swift
//  RootCMDHelper
//
//  Created by Alex Demerjian on 2/28/24.
//

import Foundation

enum JamfError: LocalizedError{
    case failedToSyncPolicies
    case failedToReportInventory
    
    var errorDescription: String?{
        switch self{
        case .failedToSyncPolicies: return "Failed to sync the policies with jamf."
        case .failedToReportInventory: return "Failed to report inventory to jamf."
        }
    }
}
