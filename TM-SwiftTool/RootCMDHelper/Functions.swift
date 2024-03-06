//
//  Functions.swift
//  RootCMDHelper
//
//  Created by Alex Demerjian on 2/28/24.
//

import Foundation

public class Functions: NSObject, RootCMDHelperProtocol, NSXPCListenerDelegate{
    public func jamfSyncPolicies(completion: @escaping (Error?) -> Void) {
        let task = Process()
        task.launchPath = "/usr/bin/jamf"
        task.arguments = ["policy"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do{
            try task.run()
        }
        catch{
            completion(error)
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        if !output.contains("Checking for policies"){
            completion(JamfError.failedToSyncPolicies)
        }
    }
    
    public func jamfReportInventory(completion: @escaping (Error?) -> Void) {
        
        let task = Process()
        task.launchPath = "/usr/bin/jamf"
        task.arguments = ["recon"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do{
            try task.run()
        }catch{
            completion(error)
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        if !output.contains("Retrieving inventory preferences"){
            completion(JamfError.failedToSyncPolicies)
        }
        
    }
    
    
    public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: RootCMDHelperProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
    }
    
    
    
}


