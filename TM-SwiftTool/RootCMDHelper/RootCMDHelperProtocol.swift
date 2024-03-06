//
//  RootCMDHelperProtocol.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/28/24.
//

import Foundation

@objc public protocol RootCMDHelperProtocol{
    func jamfSyncPolicies(completion: @escaping (Error?) -> Void)
    func jamfReportInventory(completion: @escaping (Error?) -> Void)
}
