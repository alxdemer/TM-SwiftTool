//
//  InfoViewModel.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation

public class InfoViewModel: ObservableObject{
    
    @Published var hostName: String? = nil
    @Published var currentUser: String? = nil
    @Published var osVersion: String? = nil
    @Published var model: MacModel? = nil
    @Published var serialNumber: String? = nil
    @Published var processor: String? = nil
    @Published var ramInfo: String? = nil
    @Published var storageInfo: String? = nil
    
    init(){
        
        //get the hostname
        var hostname = ProcessInfo.processInfo.hostName
        if let endIndex = hostname.range(of: "."){
            hostname = String(hostname.prefix(upTo: endIndex.lowerBound))
        }
        self.hostName = hostname
        
        //get the current user
        self.currentUser = NSUserName()
        
        //get the os version
        self.osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        
        Task.init{
            
            //get the mac model
            do{
                async let _ = try getMacModel()
            }catch{
                print(error.localizedDescription)
            }
            
            //get the serial number
            async let _ = getSerialNumber()
            //get the processor
            async let _ = getProcessor()
            
            //get RAM info
            do{
                async let _ = try getRAMInfo()
            }catch{
                print(error.localizedDescription)
            }
            
            //get the storage info
            do{
                async let _ = try getStorageInfo()
            }catch{
                print(error.localizedDescription)
            }
            
            
        }
        
    }
    
    /// Gets the model of the Mac by getting the IOPlatformExpertDevice service and retrieving the "model" cf property.
    ///
    private func getMacModel() async throws {
        
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        
        guard let modelIdentifierData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data else {throw InfoRetrievalError.macModel}
        
        guard let modelIdentifier = String(data: modelIdentifierData, encoding: .utf8) else {throw InfoRetrievalError.macModel}
        
        let start = modelIdentifier.startIndex
        let end = modelIdentifier.index(before: modelIdentifier.endIndex)
        
        let model = MacModel.init(rawValue: String(modelIdentifier[start..<end]))
        
        IOObjectRelease(service)
        
        DispatchQueue.main.async{
            self.model = model
        }
        
    }
    
    /// Gets the serial number of the Mac by using the "ioreg -l | grep IOPlatformSerialNumber" terminal command.
    ///
    private func getSerialNumber() async {
        
        let serialNumberResponse = shell("ioreg -l | grep IOPlatformSerialNumber")
        let start = serialNumberResponse.index(serialNumberResponse.startIndex, offsetBy: 36)
        let end = serialNumberResponse.index(serialNumberResponse.endIndex, offsetBy: -2)
        let serialNumber = String(serialNumberResponse[start..<end])
        
        DispatchQueue.main.async{
            self.serialNumber = serialNumber
        }
        
    }
    
    /// Gets the processor of the Mac by using the "machdep.cpu.brand_string terminal" command.
    ///
    private func getProcessor() async {
        
        let processorResponse = shell("sysctl -n machdep.cpu.brand_string")
        let start = processorResponse.index(processorResponse.startIndex, offsetBy: 0)
        let end = processorResponse.index(processorResponse.endIndex, offsetBy: -1)
        let processor = String(processorResponse[start..<end])
        
        DispatchQueue.main.async{
            self.processor = processor
        }
        
    }
    
    private func getRAMInfo() async throws{
        
        var commandShellResponse = shell("system_profiler SPHardwareDataType SPMemoryDataType")
        commandShellResponse = commandShellResponse.replacingOccurrences(of: "\n", with: "")
        
        guard let startRange = commandShellResponse.range(of: "Memory:") else {throw InfoRetrievalError.ramInfo}
        guard let endRange = commandShellResponse.range(of: "     System Firmware Version:") else {throw InfoRetrievalError.ramInfo}
        
        let startIndex = commandShellResponse.index(after: startRange.upperBound)
        let endIndex = commandShellResponse.index(before: endRange.lowerBound)
        
        let ramInfo = commandShellResponse[startIndex..<endIndex]
        
        DispatchQueue.main.async{
            self.ramInfo = String(ramInfo)
        }
        
    }
    
    /// Gets the storage info of the Mac by requesting the info of "diskutil info /dev/disk0" diskutil.
    ///
    private func getStorageInfo() async throws {
        
        let commandShellResponse = shell("diskutil info /dev/disk0")
        
        guard let startRange = commandShellResponse.range(of: "Device / Media Name:      ") else {throw InfoRetrievalError.storageInfo}
        guard let endRange = commandShellResponse.range(of: "   Volume Name:") else {throw InfoRetrievalError.storageInfo}
        
        var startIndex = commandShellResponse.index(after: startRange.upperBound)
        var endIndex = commandShellResponse.index(before: endRange.lowerBound)
        
        let SSDHDDModel = commandShellResponse[startIndex..<endIndex]
        
        guard let startRange = commandShellResponse.range(of: "Disk Size:                ") else {throw InfoRetrievalError.storageInfo}
        guard let endRange = commandShellResponse.range(of: "B (") else {throw InfoRetrievalError.storageInfo}
        
        startIndex = commandShellResponse.index(after: startRange.upperBound)
        endIndex = commandShellResponse.index(before: endRange.upperBound)
        
        let SSDHDDSize = commandShellResponse[startIndex..<endIndex]
        
        let SSDHDDInfo = (SSDHDDModel+SSDHDDSize).replacingOccurrences(of: "\n", with: " ")
        
        DispatchQueue.main.async{
            self.storageInfo = String(SSDHDDInfo)
        }
        
    }
}
