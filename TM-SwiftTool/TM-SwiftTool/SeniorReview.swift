//
//  SeniorReview.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 1/27/23.
//

import Foundation
import AVFoundation

public protocol SeniorReviewDelegate: AnyObject{
    func audioTesterError(error: Error)
    func seniorReviewComplete(seniorReviewResults: [SeniorReviewResult])
    func audioTesterStarted()
    func audioTesterStopped()
}

public class SeniorReview{
    
    public var audioTester: AVAudioPlayer? = nil
    public weak var delegate: SeniorReviewDelegate? = nil
    
    public init(){
        
        guard let songDirectory = Bundle.main.url(forResource: Song.randomCase().rawValue, withExtension: "mp3", subdirectory: "Songs") else {
            print("Failed to find the songs directory.")
            return
        }
        
        do{
            self.audioTester = try AVAudioPlayer(contentsOf: songDirectory)
        }catch{
            print("Failed to create an AVAudioPlayer object. \(error.localizedDescription)")
        }
        
    }
    
    /// Starts the Senior Review which checks the apps, storage health, battery health, camera, and audio.
    public func start() async{
        
        //stop any audioTester that is currently playing
        audioTester?.stop()
        
        //inform delegate audio tester stopped
        delegate?.audioTesterStopped()
        
        var seniorReviewResults: [SeniorReviewResult] = []
        
        async let appsResults = verifyApps()
        async let verifyUpdatesInstalled = verifyUpdatesInstalled()
        async let verifyWifiNetworkResult = verifyWifiNetwork()
        async let verifyStorageHealthResult = verifyStorageHealth()
        async let verifyBatteryHealthResult = verifyBatteryHealth()
        
        //verify that the camera works
        let _ = shell("open facetime://")
        sleep(8)
        let _ = shell("killall FaceTime")
        
        await seniorReviewResults += appsResults
        await seniorReviewResults.append(verifyUpdatesInstalled)
        await seniorReviewResults.append(verifyWifiNetworkResult)
        await seniorReviewResults.append(verifyStorageHealthResult)
        await seniorReviewResults.append(verifyBatteryHealthResult)
        
        do{
            
            //create new audio player object with random song
            audioTester = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Song.randomCase().rawValue, withExtension: "mp3", subdirectory: "Songs")!)
            
            //set volume to level 3
            let _ = shell("osascript -e \"set Volume 3\"")
            
            //play the audio
            audioTester?.play()
            
            //inform delegate that audio tester started
            delegate?.audioTesterStarted()
            
        }catch{
            
            //inform delegate that error occurred when trying to start the audio tester
            delegate?.audioTesterError(error: SeniorReviewError.failedToStartAudioTest(error: error))
            
            delegate?.seniorReviewComplete(seniorReviewResults: seniorReviewResults)
            
        }
        
        delegate?.seniorReviewComplete(seniorReviewResults: seniorReviewResults)
    }
    
    /// Verifies that the correct apps are installed.
    ///
    /// - Returns: An array of SeniorReviewResult enums indicating if each app is installed.
    private func verifyApps() async -> [SeniorReviewResult] {
        
        var results: [SeniorReviewResult] = []
        
        // get list of installed applications from MacOS
        let macOSInstalledApps = shell("ls /Applications")
        
        if macOSInstalledApps.contains("Alertus Desktop.app"){
            results.append(SeniorReviewResult.success(details: "Alertus Desktop App is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Alertus Desktop App is not installed."))
        }
        
        if macOSInstalledApps.contains("Representative Console - support.rit.edu.app"){
            results.append(SeniorReviewResult.success(details: "Remote Support Jump Client is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Remote Support Jump Client is not installed."))
        }
        
        if macOSInstalledApps.contains("SentinelOne"){
            results.append(SeniorReviewResult.success(details: "Sentinel One is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Sentinel One is not installed."))
        }
        
        if macOSInstalledApps.contains("Spirion.app"){
            results.append(SeniorReviewResult.success(details: "Spirion is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Spirion is not installed."))
        }
        
        if macOSInstalledApps.contains("Microsoft PowerPoint.app") && macOSInstalledApps.contains("Microsoft Excel.app") && macOSInstalledApps.contains("Microsoft Word.app") && macOSInstalledApps.contains("Microsoft OneNote.app"){
            
            results.append(SeniorReviewResult.success(details: "Microsoft Office is installed."))
            
        }else{
            results.append(SeniorReviewResult.failure(details: "Microsoft Office is not installed."))
        }
        
        if macOSInstalledApps.contains("Microsoft Outlook.app"){
            results.append(SeniorReviewResult.success(details: "Microsoft Outlook is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Microsoft Outlook is not installed."))
        }
        
        if macOSInstalledApps.contains("RIT Self Service.app"){
            results.append(SeniorReviewResult.success(details: "RIT Self Service app is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "RIT Self Service app is not installed."))
        }
        
        if macOSInstalledApps.contains("Jamf Connect.app"){
            results.append(SeniorReviewResult.success(details: "Jamf Connect is installed."))
        }else{
            results.append(SeniorReviewResult.failure(details: "Jamf Connect is not installed."))
        }
        
        return results
        
    }
    
    /// Verifies all updates have been installed.
    ///
    /// - Returns: SeniorReviewResult enum indicating if the Mac's software is all up to date.
    private func verifyUpdatesInstalled() async -> SeniorReviewResult{
        
        let softwareUpdateStatus = shell("softwareupdate -l")
        
        if softwareUpdateStatus.contains("No new software available."){
            return SeniorReviewResult.success(details: "All software is up to date.")
        }else{
            return SeniorReviewResult.failure(details: "There are pending software updates.")
        }
        
    }
    
    /// Verifies that the Mac is connected to the correct wifi network via the "networksetup -getairportnetwork en0" shell command.
    ///
    /// - Returns: SeniorReviewResult enum indicating if the Mac is connected to the correct wifi network.
    private func verifyWifiNetwork() async -> SeniorReviewResult{
        
        let wifiNetworkInfo = shell("networksetup -getairportnetwork en0")
        
        //get the name of the network
        let start = wifiNetworkInfo.index(after: wifiNetworkInfo.range(of: "Current Wi-Fi Network:")!.upperBound)
        let wifiNetworkName = wifiNetworkInfo[start..<wifiNetworkInfo.index(before: wifiNetworkInfo.endIndex)]
        
        if wifiNetworkName == "eduroam"{
            return SeniorReviewResult.success(details: "Connected to eduroam.")
        }else{
            return SeniorReviewResult.failure(details: "Not connected to eduroam.")
        }
    }
    
    /// Verifies the health of the storage via the "diskutil info /dev/disk0" shell command.
    ///
    /// - Returns: SeniorReviewResult enum indicating the storage health.
    private func verifyStorageHealth() async -> SeniorReviewResult{
        
        //get drive info
        let driveInfo = shell("diskutil info /dev/disk0")
        
        //get the smart status of the drive
        let start = driveInfo.index(after: driveInfo.range(of: "SMART Status:             ")!.upperBound)
        let end = driveInfo.index(before: driveInfo.range(of: "\n   Disk Size:")!.lowerBound)
        let smartStatus = driveInfo[start..<end]
        
        //verify that smart status of the drive checks out
        if smartStatus == "Verified"{
            return SeniorReviewResult.success(details: "SMART Status reports that storage health is good.")
        }
        else if smartStatus == "Failing"{
            return SeniorReviewResult.failure(details: "SMART Status reports that storage health is bad.")
        }else{
            return SeniorReviewResult.failure(details: "Could not verify the health of the storage.")
        }
        
    }
    
    /// Verifies the battery health via the "system_profiler SPPowerDataType" shell command.
    ///
    /// - Returns: SeniorReviewResult enum indicating the battery health.
    private func verifyBatteryHealth() async -> SeniorReviewResult{
        
        //get power info
        let powerInfo = shell("system_profiler SPPowerDataType")
        
        //if the power info contains battery information, get the maximum capacity
        if powerInfo.contains("Maximum Capacity:"){
            
            //get the maximum capacity of the battery
            let start = powerInfo.index(after: powerInfo.range(of: "Maximum Capacity:")!.upperBound)
            let end = powerInfo.index(before: powerInfo.range(of: "\n    System Power Settings:")!.lowerBound)
            let batteryCapacity = powerInfo[start..<end].dropLast()
            
            //verify that battery maximum capacity is above 75%
            if Int(batteryCapacity)! >= 75{
                return SeniorReviewResult.success(details: "The battery health is okay. Maximum capacity is above 75%.")
            }else{
                return SeniorReviewResult.failure(details: "The maximum capacity of the battery is below 75%. Consider replacing the battery.")
            }
            
        //else
        }else{
            
            return SeniorReviewResult.failure(details: "Could not verify the health of the battery.")
            
        }
        
    }
    
    public func startAudioTester(){
        
        do{
            audioTester = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: Song.randomCase().rawValue, withExtension: "mp3", subdirectory: "Songs")!)
            let _ = shell("osascript -e \"set Volume 3\"")
            audioTester?.play()
            
        }catch{
            delegate?.audioTesterError(error: SeniorReviewError.failedToStartAudioTest(error: error))
        }
        
    }
    
    public func stopAudioTester(){
        audioTester?.stop()
    }
    
}
