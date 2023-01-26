//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import AVKit
import DeviceGuru

struct ContentView: View {
    
    //get computer hostname
    let systemHostName = ProcessInfo.processInfo.hostName
    let userName = NSUserName()
    let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let hardware = ProcessInfo.processInfo.description
    let systemArchitecture = DeviceGuru().hardwareString()
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "mp3")!))
    @State var testAudioImage = "play.circle.fill"
    @State private var userPassword = ""
    @State var showSheet = false
    @State var seniorReviewStarted = false
    @State var showLoadingIndicator = false
    @State var seniorReviewProgress = 0.0
    @State var seniorReviewResult = ""
    
    
    
    var body: some View {
        VStack {
            
            HStack
            {
                VStack
                {
                    HStack
                    {
                        Image(systemName: "gearshape.2.fill")
                        Text("System Info")
                            .underline()
                            .padding()
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    Text("Hostname: " + systemHostName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Username: " + userName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("MacOS: " + systemVersion)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("System Architecture: " + systemArchitecture)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack
                {
                    HStack
                    {
                        Image(systemName: "cpu.fill")
                        Text("Hardware Info")
                            .underline()
                            .padding()
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("Model: " + getMacModel()!.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Serial: " + getMacSerial())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Processor: " + getMacProcessor())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            
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
                    ProgressView("Progress", value: seniorReviewProgress, total: 100.0).padding([.leading, .trailing], 50)
                }
                
                if showLoadingIndicator == true
                {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            
            
            Text(seniorReviewResult).padding()
            
        }
        .padding()
        .sheet(isPresented: $showSheet, content:{
            
            VStack
            {
                Text("Authentication")
                    .font(.largeTitle)
                    .padding()
                
                Text("Please enter your account password for sudo priviledges.")
                SecureField("Password", text: $userPassword).keyboardShortcut(.return).onSubmit {
                    
                    showSheet = false
                    seniorReviewStarted = true
                    showLoadingIndicator = true
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        start()
                    }
                }
                Button(action: {
                    
                    showSheet = false
                    seniorReviewStarted = true
                    showLoadingIndicator = true
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        start()
                    }
                    
                }, label: {Text("Start")})
            }
            .padding()
            
        })
        
    }
    
    public func getMacModel() -> String?
    {
        let service = IOServiceGetMatchingService(kIOMainPortDefault,
                                                  IOServiceMatching("IOPlatformExpertDevice"))
        var modelIdentifier: String?

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
                                        "iMac14,1": "iMac (21.5-inch, Late 2013)", "Mac14,7": "MacBook Pro (13-inch, M2, 2022)", "MacBookPro18,3": "MacBook Pro (14-inch, 2021)",
                                        "MacBookPro18,4": "MacBook Pro (14-inch, 2021)", "MacBookPro18,1": "MacBook Pro (16-inch, 2021)", "MacBookPro18,2": "MacBook Pro (16-inch, 2021)",
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
                                           "MacBookPro10,2": "MacBook Pro (Retina, 13-inch, Early 2013)", "Mac14,2":"MacBook Air (M2, 2022)", "MacBookAir10,1": "MacBook Air (M1, 2020)", "MacBookAir9,1": "MacBook Air (Retina, 13-inch, 2020)",
                                           "MacBookAir8,2": "MacBook Air (Retina, 13-inch, 2019)", "MacBookAir8,1":"MacBook Air (Retina, 13-inch, 2018)", "MacBookAir7,2": "MacBook Air (13-inch, 2017)/MacBook Air (13-inch, Early 2015)",
                                           "MacBookAir7,1": "MacBook Air (11-inch, Early 2015)", "MacBookAir6,2": "MacBook Air (13-inch, Early 2014)/MacBook Air (13-inch, Mid 2013)",
                                           "MacBookAir6,1": "MacBook Air (11-inch, Early 2014)/MacBook Air (11-inch, Mid 2013)", "Macmini9,1":"Mac mini (M1, 2020)", "Macmini8,1":"Mac mini (2018)", "Macmini7,1": "Mac mini (Late 2014)",
                                           "Mac13,1": "Mac Studio (2022) M1 Max", "Mac13,2": "Mac Studio (2022) M1 Ultra"]
        
        if (macModels.keys.contains(modelIdentifier!))
        {
            modelIdentifier = macModels[modelIdentifier!]
        }

        IOObjectRelease(service)
        
        
        
        return modelIdentifier
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
    
    func start()
    {
        
        
        let munkiUpdatesResponse = sudoShell(command: "/usr/local/munki/managedsoftwareupdate", argument: "--checkonly", password: userPassword)
        
        DispatchQueue.main.async {
            seniorReviewProgress = 10.0
        }
        
        if munkiUpdatesResponse.contains("The following items will be installed or upgraded:")
        {
            seniorReviewResult = seniorReviewResult + "!Munki has pending updates!"
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "Munki is all up to date."
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
            seniorReviewResult = seniorReviewResult + "Remote Support Jump Client is installed.\n"
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "!Remote Support Jump Client is NOT installed!"
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 55.0
        }
        
        if munkiInstalledItems.contains("Sentinel One") && munkiInstalledItems.contains("sentinelone_registration_token")
        {
            seniorReviewResult = seniorReviewResult + "Sentinel One is installed."
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "!Sentinel One is NOT installed!"
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 65.0
        }
        
        if munkiInstalledItems.contains("Rapid7Agent")
        {
            seniorReviewResult = seniorReviewResult + "Rapid7 Agent is installed."
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "!Rapid7 Agent is NOT installed!"
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 75.0
        }
        
        
        if munkiInstalledItems.contains("Rapid7Agent")
        {
            seniorReviewResult = seniorReviewResult + "Rapid7 Agent is installed."
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "!Rapid7 Agent is NOT installed!"
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 85.0
        }
        
        if munkiInstalledItems.contains("Office 2021 VL")
        {
            seniorReviewResult = seniorReviewResult + "Office 2021 is installed."
        }
        else
        {
            seniorReviewResult = seniorReviewResult + "!Office 2021 is NOT installed!"
        }
        
        DispatchQueue.main.async
        {
            seniorReviewProgress = 100.0
            
            seniorReviewStarted = false
            showLoadingIndicator = false
        }
        
    }

}
