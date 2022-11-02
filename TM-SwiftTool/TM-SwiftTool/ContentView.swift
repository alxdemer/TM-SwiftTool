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
            
        }
        .padding()
    }
    
    public func getMacModel() -> String? {
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
    

    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        
        return output
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
