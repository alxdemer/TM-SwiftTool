//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import AVKit
import DeviceGuru

struct MainView: View {
    
    //get computer hostname
    let systemHostName = ProcessInfo.processInfo.hostName
    let userName = NSUserName()
    let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let hardware = ProcessInfo.processInfo.description
    let systemArchitecture = DeviceGuru().hardwareString()
    let macModelFinder = MacModelFinder()
    
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "mp3")!))
    @State var testAudioImage = "play.circle.fill"
    @State private var userPassword = ""
    @State var showSheet = false
    
    @State var seniorReviewStarted = false
    @State var showLoadingIndicator = false
    @State var seniorReviewProgress = 0.0
    
    @State var seniorReviewMunkiUpdates = ""
    @State var seniorReviewJumpClient = ""
    @State var seniorReviewSentinel = ""
    @State var seniorReviewRapid7 = ""
    @State var seniorReviewOffice21 = ""
    
    
    
    var body: some View
    {
        
        VStack
        {
            
            VStack
            {
                //dispay headers for system info column and hardware info column
                HStack
                {
                    HStack
                    {
                        Image(systemName: "gearshape.2.fill")
                        Text("System Info")
                            .underline()
                            .font(.system(size: 15, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack
                    {
                        Image(systemName: "cpu.fill")
                        Text("Hardware Info")
                            .underline()
                            .font(.system(size: 15, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                .padding()
                
                Divider()
                
                //display info in each column under header
                HStack
                {
                    VStack
                    {
                        
                        HStack
                        {
                            Text("Hostname: ")
                                .bold()
                            Text(systemHostName)
                                
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        HStack
                        {
                            Text("Username: ")
                                .bold()
                            Text(userName)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        HStack
                        {
                            Text("MacOS: ")
                                .bold()
                            Text(systemVersion)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        HStack
                        {
                            Text("System Architecture: ")
                                .bold()
                            Text(systemArchitecture)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                    }
                    VStack
                    {
                        HStack
                        {
                            Text("Model: ")
                                .bold()
                            Text(macModelFinder.getMacModel()!.description)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        HStack
                        {
                            Text("Serial: ")
                                .bold()
                            Text(getMacSerial())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        
                        HStack
                        {
                            Text("Processor: ")
                                .bold()
                            Text(getMacProcessor())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        HStack
                        {
                            Text("HDD/SSD: ")
                                .bold()
                            Text(getMacSSDHDD())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                    }
                }
                
                Divider()
                
            }
            .padding()
                
            
            HStack()
            {
                Button()
                {
                    showSheet = true
                }
                label:
                {
                    Image(systemName: "checkmark.square.fill")
                    Text("Senior Review")
                    
                }
                
                Button()
                {
                    if (!self.audioPlayer.isPlaying)
                    {
                        testAudioImage = "stop.circle.fill"
                        self.audioPlayer.play()
                        shell("osascript -e \"set Volume 3\"")
                    }
                    else
                    {
                        testAudioImage = "play.circle.fill"
                        self.audioPlayer.stop()
                    }
                }
                label:
                {
                    
                    Image(systemName: testAudioImage)
                    Text("Test Audio")
                    
                }
            }
            
            HStack
            {
                if seniorReviewStarted == true
                {
                    ProgressView("Progress", value: seniorReviewProgress, total: 100.0).padding(.leading, 30)
                }
                
                if showLoadingIndicator == true
                {
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(0.5)
                        .padding()
                }
            }
            .padding()
            
            
            HStack
            {
                VStack
                {
                    Text(seniorReviewMunkiUpdates)
                    Text(seniorReviewJumpClient)
                    Text(seniorReviewSentinel)
                    Text(seniorReviewRapid7)
                }
                .padding()
                
                VStack
                {
                    Text(seniorReviewOffice21)
                }
                .padding()
            }
            
        }
        .padding()
        .sheet(isPresented: $showSheet, content:{
            
            VStack
            {
                HStack
                {
                    Image(systemName: "key.fill")
                        .resizable()
                        .frame(width: 10, height: 20)
                    Text("Authentication")
                        .font(.largeTitle)
                }
                
                Text("Please enter your admin password:")
                    .padding([.leading, .trailing])
                
                SecureField("Password", text: $userPassword).keyboardShortcut(.return).onSubmit {
                    
                    showSheet = false
                    seniorReviewStarted = true
                    showLoadingIndicator = true
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        start()
                    }
                }
                .padding([.leading, .top, .trailing])
                
                HStack
                {
                    Button(action: {
                        
                        showSheet = false
                        seniorReviewStarted = true
                        showLoadingIndicator = true
                        
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            start()
                            userPassword = ""
                        }
                        
                    }, label: {Text("Start")})
                    .padding()
                    
                    Button(action: {
                        
                        showSheet = false
                        userPassword = ""
                        
                    }, label: {Text("Cancel")})
                    .padding()
                    
                    
                }
                
            }
            .padding()
            
        })
        
    }
    
    
    
    
    
    
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
    
    func start()
    {
        seniorReviewMunkiUpdates = ""
        seniorReviewJumpClient = ""
        seniorReviewSentinel = ""
        seniorReviewRapid7 = ""
        seniorReviewOffice21 = ""
        
        let munkiUpdatesResponse = sudoShell(command: "/usr/local/munki/managedsoftwareupdate", argument: "--checkonly", password: userPassword)
        
        DispatchQueue.main.async {
            seniorReviewProgress = 10.0
        }
        
        if munkiUpdatesResponse.contains("The following items will be installed or upgraded:")
        {
            seniorReviewMunkiUpdates = "FAILURE - Munki has pending updates"
        }
        else
        {
            seniorReviewMunkiUpdates = "SUCCESS - Munki is all up to date."
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 25.0
        }
        
        let munkiManagedInstallReport = shell("defaults read /Library/'Managed Installs'/ManagedInstallReport.plist")
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 30.0
        }
        
        //get substring related to installed items
        let start = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "InstalledItems")!.lowerBound)
        let end = munkiManagedInstallReport.index(before: munkiManagedInstallReport.range(of: "ItemsToInstall")!.lowerBound)
        let range = start..<end
        let munkiInstalledItems = munkiManagedInstallReport[range]
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 45.0
        }
        
        if munkiInstalledItems.contains("JumpClient")
        {
            seniorReviewJumpClient = "SUCCESS - Remote Support Jump Client is installed.\n"
        }
        else
        {
            seniorReviewJumpClient = "FAILURE - Remote Support Jump Client is NOT installed."
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 55.0
        }
        
        if munkiInstalledItems.contains("SentinelOne") && munkiInstalledItems.contains("sentinelone_registration_token")
        {
            seniorReviewSentinel = "SUCCESS - Sentinel One is installed."
        }
        else
        {
            seniorReviewSentinel = "FAILURE - Sentinel One is NOT installed."
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 65.0
        }
        
        if munkiInstalledItems.contains("Rapid7Agent")
        {
            seniorReviewRapid7 = "SUCCESS - Rapid7 Agent is installed."
        }
        else
        {
            seniorReviewRapid7 = "FAILURE - Rapid7 Agent is NOT installed."
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 85.0
        }
        
        if munkiInstalledItems.contains("Office 2021 VL")
        {
            seniorReviewOffice21 = "SUCCESS - Office 2021 is installed."
        }
        else
        {
            seniorReviewOffice21 = "FAILURE - Office 2021 is NOT installed."
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 100.0
            
            seniorReviewStarted = false
            showLoadingIndicator = false
        }
        
    }

}
