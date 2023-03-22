//
//  SeniorReview.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 1/27/23.
//

import Foundation
import AVFAudio

struct SeniorReview
{
    //function to perform Senior Review
    func start() -> [String: String]
    {
        
        var results: [String: String] = [:]
        
        let munkiUpdatesResponse = sudoShell(command: "/usr/local/munki/managedsoftwareupdate", argument: "--checkonly", password: getFromKeychain()!)
        
        //after making use of the adminPassword stored in keychain, delete it
        deleteFromKeychain()
        
        if munkiUpdatesResponse.contains("no such file or directory") || munkiUpdatesResponse.contains("command not found")
        {
            results["munkiUpdates"] = "FAILURE - Could not talk to managed software center. It may not be installed or is malfunctioning."
        }
        else if munkiUpdatesResponse.contains("The following items will be installed or upgraded:")
        {
            results["munkiUpdates"] = "FAILURE - Munki has pending updates"
        }
        else
        {
            results["munkiUpdates"] = "SUCCESS - Munki is all up to date."
        }
        
        //get managed install report from munki
        let munkiManagedInstallReport = shell("defaults read /Library/'Managed Installs'/ManagedInstallReport.plist")
        
        //if munkiManagedInstallReport content comes back with does not exist, set all expected apps results to failure
        if munkiManagedInstallReport.contains("does not exist")
        {
            results["jumpClient"] = "FAILURE - Managed software center installed apps list could not be found."
            results["sentinelOne"] = ""
            results["rapid7"] = ""
            results["office2021"] = ""
        }
        else
        {
            //if munkiManagedInstallReport content is present, substring it to get the installed items
            let start = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "InstalledItems")!.lowerBound)
            let end = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "ItemsToInstall")!.lowerBound)
            let range = start..<end
            let munkiInstalledItems = munkiManagedInstallReport[range]
            
            if munkiInstalledItems.contains("JumpClient")
            {
                results["jumpClient"] = "SUCCESS - Remote Support Jump Client is installed."
            }
            else
            {
                results["jumpClient"] = "FAILURE - Remote Support Jump Client is not installed."
            }
            
            
            if munkiInstalledItems.contains("SentinelOne") && munkiInstalledItems.contains("sentinelone_registration_token")
            {
                results["sentinelOne"] = "SUCCESS - Sentinel One is installed."
            }
            else
            {
                results["sentinelOne"] = "FAILURE - Sentinel One is not installed."
            }
            
            
            if munkiInstalledItems.contains("Rapid7Agent")
            {
                results["rapid7"] = "SUCCESS - Rapid7 Agent is installed."
            }
            else
            {
                results["rapid7"] = "FAILURE - Rapid7 Agent is not installed."
            }
            
            
            if munkiInstalledItems.contains("Office 2021 VL")
            {
                results["office2021"] = "SUCCESS - Office 2021 is installed."
            }
            else
            {
                results["office2021"] = "FAILURE - Office 2021 is not installed."
            }
            
        }
        
        //get list of installed applications from MacOS
        let macOSInstalledApps = shell("ls /Applications")
        
        //verify that alertus desktop app is installed
        if macOSInstalledApps.contains("Alertus Desktop.app")
        {
            results["alertusDesktopApp"] = "SUCCESS - Alertus Desktop App is installed."
        }
        else
        {
            results["alertusDesktopApp"] = "FAILURE - Alertus Desktop App is not installed."
        }
        
        //get drive info
        let driveInfo = shell("diskutil info /dev/disk0")
        
        //get the smart status of the drive
        var start = driveInfo.index(after: driveInfo.range(of: "SMART Status:             ")!.upperBound)
        var end = driveInfo.index(before: driveInfo.range(of: "\n   Disk Size:")!.lowerBound)
        var range = start..<end
        let smartStatus = driveInfo[range]
        
        //verify that smart status of the drive checks out
        if smartStatus == "Verified"
        {
            results["driveSmartStatus"] = "SUCCESS - SMART Status reports that drive health is good."
        }
        else if smartStatus == "Failing"
        {
            results["driveSmartStatus"] = "FAILURE - SMART Status reports that drive health is bad."
        }
        else
        {
            results["driveSmartStatus"] = ""
        }
        
        //get power info
        let powerInfo = shell("system_profiler SPPowerDataType")
        
        //if the power info contains battery information, get the maximum capacity
        if powerInfo.contains("Maximum Capacity:")
        {
            
            //get the maximum capacity of the battery
            start = powerInfo.index(after: powerInfo.range(of: "Maximum Capacity:")!.upperBound)
            end = powerInfo.index(before: powerInfo.range(of: "\n    System Power Settings:")!.lowerBound)
            range = start..<end
            let batteryCapacity = powerInfo[range].dropLast()
            
            //verify that battery maximum capacity is above 75%
            if Int(batteryCapacity)! >= 75
            {
                results["batteryCapacity"] = "SUCCESS - Battery health is okay. Maximum capacity is above 75%."
            }
            else
            {
                results["batteryCapacity"] = "FAILURE - Maximum capacity of battery is below 75%. Consider replacing battery."
            }
        }
        
        
        //verify that the camera works
        shell("open facetime://")
        sleep(8)
        shell("killall FaceTime")
        
        return results
    }
}
