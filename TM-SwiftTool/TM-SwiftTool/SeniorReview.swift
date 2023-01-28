//
//  SeniorReview.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 1/27/23.
//

import Foundation

class SeniorReview
{
    func start(adminPassword: String) -> [String: String]
    {
        
        var results: [String: String] = [:]
        
        let munkiUpdatesResponse = sudoShell(command: "/usr/local/munki/managedsoftwareupdate", argument: "--checkonly", password: adminPassword)
        
        
        if munkiUpdatesResponse.contains("The following items will be installed or upgraded:")
        {
            results["munkiUpdates"] = "FAILURE - Munki has pending updates"
        }
        else
        {
            results["munkiUpdates"] = "SUCCESS - Munki is all up to date."
        }
        
        let munkiManagedInstallReport = shell("defaults read /Library/'Managed Installs'/ManagedInstallReport.plist")
        
        //get substring related to installed items
        let start = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "InstalledItems")!.lowerBound)
        let end = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "ItemsToInstall")!.lowerBound)
        let range = start..<end
        let munkiInstalledItems = munkiManagedInstallReport[range]
        
        if munkiInstalledItems.contains("JumpClient")
        {
            results["jumpClient"] = "SUCCESS - Remote Support Jump Client is installed.\n"
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
        
        shell("open facetime://")
        
        sleep(8)
        
        shell("killall FaceTime")
        
        return results
    }
}
