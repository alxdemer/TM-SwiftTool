//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import AVFoundation
import DeviceGuru

struct MainView: View {
    
    //get computer hostname
    let systemHostName = ProcessInfo.processInfo.hostName
    let userName = NSUserName()
    let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let hardware = ProcessInfo.processInfo.description
    let systemArchitecture = DeviceGuru().hardwareString()
    let macModelFinder = MacModelFinder()
    
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: ["Life is a Highway", "No Pomegranates Trap Remix", "Smash Mouth - All Star","The Home Depot Beat"].randomElement(), withExtension: "mp3", subdirectory: "Songs")!)
    @State var isPlaying = false
    @State private var adminPassword = ""
    @State var newUserName = ""
    @State var addUserResult = ""
    @State var showAdminSheet = false
    @State var goingToPerformSeniorReview = false
    
    @State var seniorReview = SeniorReview()
    @State var isPerformingSeniorReview = false
    @State var disableSeniorReviewButton = false
    
    @State var results: [String:String] = [:]
    
    
    
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
                    showAdminSheet = true
                    addUserResult = ""
                    results = [:]
                }
                label:
                {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Add User")
                }
                
                Button()
                {
                    goingToPerformSeniorReview = true
                    showAdminSheet = true
                    addUserResult = ""
                    results = [:]
                }
                label:
                {
                    Image(systemName: "checkmark.square.fill")
                    Text("Senior Review")
                    
                }
                .disabled(disableSeniorReviewButton)
                
                Button()
                {
                    
                    if (!audioPlayer.isPlaying)
                    {
                        isPlaying = true
                        audioPlayer.play()
                        shell("osascript -e \"set Volume 3\"")
                    }
                    else
                    {
                        isPlaying = false
                        audioPlayer.stop()
                    }
                     
                }
                label:
                {
                    
                    Image(systemName: isPlaying ? "stop.circle.fill":"play.circle.fill")
                    
                    Text("Test Audio")
                    
                }
            }
            
            HStack
            {
                if isPerformingSeniorReview == true
                {
                    Text("Performing Senior Review")
                    
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(0.5)
                }
            }
            .padding()
            
            
            HStack
            {
                VStack
                {
                    Text(results["munkiUpdates"] ?? "")
                    Text(results["jumpClient"] ?? "")
                    Text(results["sentinelOne"] ?? "")
                    Text(results["rapid7"] ?? "")
                }
                .padding()
                
                VStack
                {
                    Text(results["office2021"] ?? "")
                }
                .padding()
            }
            
            
            Text(addUserResult)
                .padding()
            
            Text("© 2023 RIT ITS")
            Text("Beta 2")
            
        }
        .padding()
        .sheet(isPresented: $showAdminSheet, content:{
            
            VStack
            {
                if goingToPerformSeniorReview == true
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
                    
                    SecureField("Password", text: $adminPassword).keyboardShortcut(.return).onSubmit {
                        
                        showAdminSheet = false
                        isPerformingSeniorReview = true
                        disableSeniorReviewButton = true
                        
                        DispatchQueue.global(qos: .userInitiated).async
                        {
                            results = seniorReview.start(AdminPassword: adminPassword)
                            
                            DispatchQueue.main.async
                            {
                                isPlaying = true
                                audioPlayer.play()
                                adminPassword = ""
                                goingToPerformSeniorReview = false
                                isPerformingSeniorReview = false
                                disableSeniorReviewButton = false
                            }
                        }
                        
                    }
                    .padding([.leading, .top, .trailing])
                    
                    HStack
                    {
                        Button(action: {
                            
                            showAdminSheet = false
                            isPerformingSeniorReview = true
                            disableSeniorReviewButton = true
                            
                            DispatchQueue.global(qos: .userInitiated).async
                            {
                                results = seniorReview.start(AdminPassword: adminPassword)
                                
                                DispatchQueue.main.async
                                {
                                    isPlaying = true
                                    audioPlayer.play()
                                    adminPassword = ""
                                    goingToPerformSeniorReview = false
                                    isPerformingSeniorReview = false
                                    disableSeniorReviewButton = false
                                }
                            }
                            
                        }, label: {Text("Start")})
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        Button(action: {
                            
                            goingToPerformSeniorReview = false
                            showAdminSheet = false
                            adminPassword = ""
                            newUserName = ""
                            
                        }, label: {Text("Cancel")})
                        .padding()
                        
                        
                    }
                }
                else
                {
                    HStack
                    {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Add User")
                            .font(.largeTitle)
                    }
                    
                    
                    Text("Please enter the username for the new user and your admin password:")
                        .padding([.leading, .trailing])
                    
                    TextField("New Username", text: $newUserName)
                        .padding([.leading, .trailing])
                    
                    SecureField("Your Admin Password", text: $adminPassword)
                        .padding([.leading, .trailing])
                    
                    HStack
                    {
                        Button(action: {
        
                            
                            DispatchQueue.global(qos: .userInitiated).async
                            {
                                
                                //run the shell script to add the new user
                                sudoShellCreateNewUser(command: "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", password: adminPassword, newUserName: newUserName)
                                
                                //check if the new user was added
                                let userAdded = shell("dscl . -list /Users").contains(userName)
                                
                                //let the user know if the new user was added
                                DispatchQueue.main.async {
                                    if userAdded
                                    {
                                        addUserResult = "Successfully added user!"
                                        adminPassword = ""
                                        showAdminSheet = false
                                    }
                                    else
                                    {
                                        addUserResult = "Failed to add user!"
                                        adminPassword = ""
                                        showAdminSheet = false
                                    }
                                }
                            }
                            
                        }, label: {Text("Add")})
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        Button(action: {
                            
                            showAdminSheet = false
                            adminPassword = ""
                            
                        }, label: {Text("Cancel")})
                        .padding()
                        
                        
                    }
                    
                    
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

    
}

