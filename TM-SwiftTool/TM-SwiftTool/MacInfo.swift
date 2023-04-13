//
//  ComputerInfo.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import Foundation
import IOKit
import DeviceGuru

/*
 This class contains methods and variables to get the hardware information of the current Mac.
 */

class MacInfo
{
    //get the system host name
    var systemHostName = ProcessInfo.processInfo.hostName
    
    //get the username of the current logged in user
    var userName = NSUserName()
    
    //get the operating system version
    var systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    
    //get the system architecture (arm or x86)
    var systemArchitecture = DeviceGuru().hardwareString()
    
    
    //Description: Gets the current mac model using the mac model identifier.
    //Returns: Mac model as a string
    //Note: If the model identifier does not have a corresponding mac model, it will return the model identifier as a string
    public func getMacModel() -> String
    {
        var modelIdentifier = ""
        var macModel = ""
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        
        if let modelData = IORegistryEntryCreateCFProperty(service, "model" as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? Data {
            if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(using: .utf8) {
                modelIdentifier = String(cString: modelIdentifierCString)
            }
        }
        
        let macModels: [String: String] = ["iMac21,1": "iMac (24-inch, M1, 2021) w/ Four USB-C", "iMac21,2": "iMac (24-inch, M1, 2021) w/ Two USB-C", "iMac20,1": "iMac (Retina 5K, 27-inch, 2020)",
                                        "iMac20,2": "iMac (Retina 5K, 27-inch, 2020)", "iMac19,1": "iMac (Retina 5K, 27-inch, 2019)", "iMac19,2": "iMac (Retina 4K, 21.5-inch, 2019)",
                                        "iMacPro1,1": "iMac Pro (2017)", "iMac18,3": "iMac (Retina 5K, 27-inch, 2017)", "iMac18,2": "iMac (Retina 4K, 21.5-inch, 2017)", "iMac18,1": "iMac (21.5-inch, 2017)",
                                        "iMac17,1": "iMac (Retina 5K, 27-inch, Late 2015)", "iMac16,2": "iMac (Retina 4K, 21.5-inch, Late 2015)", "iMac16,1": "iMac (21.5-inch, Late 2015)",
                                        "iMac15,1": "iMac (Retina 5K, 27-inch, Mid 2015)/iMac (Retina 5K, 27-inch, Late 2014)", "iMac14,4": "iMac (21.5-inch, Mid 2014)", "iMac14,2": "iMac (27-inch, Late 2013)",
                                           "iMac14,1": "iMac (21.5-inch, Late 2013)",
                                        "Mac14,9":"MacBook Pro (14-inch, M2 Pro/Max, 2023)","Mac14,5":"MacBook Pro (14-inch, M2 Pro/Max, 2023)", "Mac14,6":"MacBook Pro (16-inch, M2 Pro/Max, 2023)","Mac14,10":"MacBook Pro (16-inch, M2 Pro/Max, 2023)","Mac14,7": "MacBook Pro (13-inch, M2, 2022)", "MacBookPro18,3": "MacBook Pro (14-inch, M1 Pro/Max, 2021)",
                                            "MacBookPro18,4": "MacBook Pro (14-inch, M1 Pro/Max, 2021)", "MacBookPro18,1": "MacBook Pro (16-inch, M1 Pro/Max, 2021)", "MacBookPro18,2": "MacBook Pro (16-inch, M1 Pro/Max, 2021)",
                                            "MacBookPro17,1": "MacBook Pro (13-inch, M1, 2020)", "MacBookPro16,3": "MacBook Pro (13-inch, 2020, Two Thunderbolt 3 ports)",
                                            "MacBookPro16,2": "MacBook Pro (13-inch, 2020, Four Thunderbolt 3 ports)", "MacBookPro16,1": "MacBook Pro (16-inch, 2019)", "MacBookPro16,4": "MacBook Pro (16-inch, 2019)",
                                            "MacBookPro15,4": "MacBook Pro (13-inch, 2019, Two Thunderbolt 3 ports)", "MacBookPro15,1": "MacBook Pro (15-inch, 2019)/MacBook Pro (15-inch, 2018)",
                                            "MacBookPro15,3": "MacBook Pro (15-inch, 2019)", "MacBookPro15,2": "MacBook Pro (13-inch, 2019, Four Thunderbolt 3 ports)/MacBook Pro (13-inch, 2018, Four Thunderbolt 3 ports)",
                                            "MacBookPro14,3": "MacBook Pro (15-inch, 2017)", "MacBookPro14,2": "MacBook Pro (13-inch, 2017, Four Thunderbolt 3 ports)",
                                            "MacBookPro14,1": "MacBook Pro (13-inch, 2017, Two Thunderbolt 3 ports)", "MacBookPro13,3": "MacBook Pro (15-inch, 2016)",
                                            "MacBookPro13,2": "MacBook Pro (13-inch, 2016, Four Thunderbolt 3 ports)", "MacBookPro13,1": "MacBook Pro (13-inch, 2016, Two Thunderbolt 3 ports)",
                                            "MacBookPro11,4": "MacBook Pro (Retina, 15-inch, Mid 2015)", "MacBookPro11,5": "MacBook Pro (Retina, 15-inch, Mid 2015)",
                                            "MacBookPro12,1": "MacBook Pro (Retina, 13-inch, Early 2015)", "MacBookPro11,2": "MacBook Pro (Retina, 15-inch, Mid 2014)/MacBook Pro (Retina, 15-inch, Late 2013)",
                                            "MacBookPro11,3": "MacBook Pro (Retina, 15-inch, Mid 2014)/MacBook Pro (Retina, 15-inch, Late 2013)",
                                            "MacBookPro11,1": "MacBook Pro (Retina, 13-inch, Mid 2014)/MacBook Pro (Retina, 13-inch, Late 2013)", "MacBookPro10,1": "MacBook Pro (Retina, 15-inch, Early 2013)",
                                            "MacBookPro10,2": "MacBook Pro (Retina, 13-inch, Early 2013)",
                                        "Mac14,2":"MacBook Air (M2, 2022)", "MacBookAir10,1": "MacBook Air (M1, 2020)", "MacBookAir9,1": "MacBook Air (Retina, 13-inch, 2020)",
                                            "MacBookAir8,2": "MacBook Air (Retina, 13-inch, 2019)", "MacBookAir8,1":"MacBook Air (Retina, 13-inch, 2018)", "MacBookAir7,2": "MacBook Air (13-inch, 2017)/MacBook Air (13-inch, Early 2015)",
                                            "MacBookAir7,1": "MacBook Air (11-inch, Early 2015)", "MacBookAir6,2": "MacBook Air (13-inch, Early 2014)/MacBook Air (13-inch, Mid 2013)",
                                            "MacBookAir6,1": "MacBook Air (11-inch, Early 2014)/MacBook Air (11-inch, Mid 2013)",
                                        "Mac14,3":"Mac mini (M2, 2023, Two Thunderbolt 4 ports)", "Mac14,12":"Mac mini (M2 Pro, 2023, Four Thunderbolt 4 ports)",
                                            "Macmini9,1":"Mac mini (M1, 2020)", "Macmini8,1":"Mac mini (2018)", "Macmini7,1": "Mac mini (Late 2014)",
                                        "Mac13,1": "Mac Studio (2022) M1 Max", "Mac13,2": "Mac Studio (2022) M1 Ultra"]
        
        if (macModels.keys.contains(modelIdentifier))
        {
            macModel = macModels[modelIdentifier]!
        }
        else
        {
            macModel = modelIdentifier
        }

        IOObjectRelease(service)
        
        return macModel
        
    }
    
    //Description: Gets the current mac serial using a shell command.
    //Returns: Mac serial as a string
    public func getMacSerial() -> String.SubSequence
    {
        let commandShellResponse = shell("ioreg -l | grep IOPlatformSerialNumber")
        let start = commandShellResponse.index(commandShellResponse.startIndex, offsetBy: 36)
        let end = commandShellResponse.index(commandShellResponse.endIndex, offsetBy: -2)
        let range = start..<end
         
        let serial = commandShellResponse[range]
        
        return serial
    }
    
    //Description: Gets the current mac processor using a shell command.
    //Returns: Mac processor as a string
    public func getMacProcessor() -> String.SubSequence
    {
        let commandShellResponse = shell("sysctl -n machdep.cpu.brand_string")
        let start = commandShellResponse.index(commandShellResponse.startIndex, offsetBy: 0)
        let end = commandShellResponse.index(commandShellResponse.endIndex, offsetBy: -1)
        let range = start..<end
        
        let processor = commandShellResponse[range]
        
        return processor
    }
    
    //Description: Gets the current mac ssd/hdd information.
    //Returns: The Mac ssd/hdd info as a string
    public func getMacSSDHDD() -> String
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
        
        var SSDHDDInfo = SSDHDDModel+SSDHDDSize
        
        return SSDHDDInfo.replacingOccurrences(of: "\n", with: " ")
    }
}
