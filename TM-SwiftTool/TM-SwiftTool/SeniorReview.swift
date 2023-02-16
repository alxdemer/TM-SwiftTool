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
    
    func start(AdminPassword: String) -> [String: String]
    {
        
        var results: [String: String] = [:]
        
        let munkiUpdatesResponse = sudoShell(command: "/usr/local/munki/managedsoftwareupdate", argument: "--checkonly", password: AdminPassword)
        
        if munkiUpdatesResponse == "sudo /usr/local/munki/managedsoftwareupdate: command not found"
        {
            results["munkiUpdates"] = "FAILURE - Could not talk to managed software center. It may not be installed properly or is malfunctioning."
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
        
        //get substring related to installed items
        let start = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "InstalledItems")!.lowerBound)
        let end = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "ItemsToInstall")!.lowerBound)
        let range = start..<end
        let munkiInstalledItems = munkiManagedInstallReport[range]
        
        if munkiInstalledItems == "dquote>"
        {
            results["jumpClient"] = "FAILURE - Managed software center installed apps list could not be found."
            results["sentinelOne"] = "FAILURE - Managed software center installed apps list could not be found."
            results["rapid7"] = "FAILURE - Managed software center installed apps list could not be found."
            results["office2021"] = "FAILURE - Managed software center installed apps list could not be found."
        }
        else
        {
            
            if munkiInstalledItems.contains("JumpClient")
            {
                results["jumpClient"] = "SUCCESS - Remote Support Jump Client is installed."
            }
            else
            {
                results["jumpClient"] = "FAILURE - Remote Support Jump Client is NOT installed."
            }
            
            
            if munkiInstalledItems.contains("SentinelOne") && munkiInstalledItems.contains("sentinelone_registration_token")
            {
                results["sentinelOne"] = "SUCCESS - Sentinel One is installed."
            }
            else
            {
                results["sentinelOne"] = "FAILURE - Sentinel One is NOT installed."
            }
            
            
            if munkiInstalledItems.contains("Rapid7Agent")
            {
                results["rapid7"] = "SUCCESS - Rapid7 Agent is installed."
            }
            else
            {
                results["rapid7"] = "FAILURE - Rapid7 Agent is NOT installed."
            }
            
            
            if munkiInstalledItems.contains("Office 2021 VL")
            {
                results["office2021"] = "SUCCESS - Office 2021 is installed."
            }
            else
            {
                results["office2021"] = "FAILURE - Office 2021 is NOT installed."
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
            results["alertusDesktopApp"] = "FAILURE - Alertus Desktop App is NOT installed."
        }
        
        
        //verify that the camera works
        shell("open facetime://")
        sleep(8)
        shell("killall FaceTime")
        
        return results
    }
}
