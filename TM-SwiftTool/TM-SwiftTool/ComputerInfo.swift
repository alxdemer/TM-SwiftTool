//
//  ComputerInfo.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import Foundation
import DeviceGuru

class ComputerInfo
{
    var systemHostName = ProcessInfo.processInfo.hostName
    var userName = NSUserName()
    var systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    var hardware = ProcessInfo.processInfo.description
    var systemArchitecture = DeviceGuru().hardwareString()
    var macModelFinder = MacModelFinder()
    
    public func getMacSerial() -> String.SubSequence
    {
        let commandShellResponse = shell("ioreg -l | grep IOPlatformSerialNumber")
        let start = commandShellResponse.index(commandShellResponse.startIndex, offsetBy: 36)
        let end = commandShellResponse.index(commandShellResponse.endIndex, offsetBy: -2)
        let range = start..<end
         
        let serial = commandShellResponse[range]
        
        return serial
    }
    
    public func getMacProcessor() -> String.SubSequence
    {
        let commandShellResponse = shell("sysctl -n machdep.cpu.brand_string")
        let start = commandShellResponse.index(commandShellResponse.startIndex, offsetBy: 0)
        let end = commandShellResponse.index(commandShellResponse.endIndex, offsetBy: -1)
        let range = start..<end
        
        let processor = commandShellResponse[range]
        
        return processor
    }
    
    public func getMacSSDHDD() -> String.SubSequence
    {
        let commandShellResponse = shell("diskutil info /dev/disk0")
        
        var start = commandShellResponse.index(after: commandShellResponse.range(of: "Device / Media Name:      ")!.upperBound)
        var end = commandShellResponse.index(before: commandShellResponse.range(of: "   Volume Name:")!.lowerBound)
        var range = start..<end
        
        let SSDHDDModel = commandShellResponse[range]
        
        start = commandShellResponse.index(after: commandShellResponse.range(of: "Disk Size:                ")!.upperBound)
        end = commandShellResponse.index(before: commandShellResponse.range(of: "B (")!.upperBound)
        range = start..<end
        
        let SSDHDDSize = commandShellResponse[range]
        
        return SSDHDDModel+SSDHDDSize
    }
}
