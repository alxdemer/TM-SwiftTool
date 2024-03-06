//
//  RootCMDHelperClient.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/28/24.
//

import Foundation

class RootCMDHelperClient{
    
    private var connection: NSXPCConnection?
    static var shared = RootCMDHelperClient()
    
    init() {
        setupConnection()
    }
    
    private func setupConnection(){
        
        connection = NSXPCConnection(serviceName: "ResLab.TM-SwiftTool.RootCMDHelper")
        connection?.remoteObjectInterface = NSXPCInterface(with: RootCMDHelperProtocol.self)
        
        connection?.invalidationHandler = {
            print("Connection invalidated")
        }
        
        connection?.resume()
    }
    
    func jamfSyncPolicies() throws{
        
        guard let remoteObject = connection?.remoteObjectProxyWithErrorHandler({ error in
            print("Received error:", error)
        }) as? RootCMDHelperProtocol else {
            print("Failed to create a remote object proxy for the helper.")
            return
        }
        
        var jamfSyncPoliciesError: Error? = nil
        
        remoteObject.jamfSyncPolicies{
            error in
            jamfSyncPoliciesError = error
        }
        
        if let jamfSyncPoliciesError = jamfSyncPoliciesError{
            throw jamfSyncPoliciesError
        }else{
            return
        }
    }
    
    func jamfReportInventory() throws{
        
        guard let remoteObject = connection?.remoteObjectProxyWithErrorHandler({ error in
            print("Received error:", error)
        }) as? RootCMDHelperProtocol else {
            print("Failed to create a remote object proxy for the helper.")
            return
        }
        
        var jamfReportInventoryError: Error? = nil
        
        remoteObject.jamfReportInventory{
            error in
            jamfReportInventoryError = error
        }
        
        if let jamfReportInventoryError = jamfReportInventoryError{
            throw jamfReportInventoryError
        }else{
            return
        }
    }
    
}
