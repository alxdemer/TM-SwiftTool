//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import DeviceGuru

struct ContentView: View {
    
    //get computer hostname
    let systemHostName = ProcessInfo.processInfo.hostName
    let userName = NSUserName()
    let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let hardware = ProcessInfo.processInfo.description
    let systemArchitecture = DeviceGuru().hardwareString()
    
    
    var body: some View {
        VStack {
            
            HStack
            {
                Text("System Info:")
                    .underline()
                    .padding()
                    .font(.system(size: 15, weight: .bold))
                
                Text("Hardware Info:")
                    .underline()
                    .padding()
                    .font(.system(size: 15, weight: .bold))
            }
            .padding()
            
            HStack
            {
                VStack
                {
                    
                    Text("Hostname: " + systemHostName)
                    Text("Username: " + userName)
                    Text("MacOS: " + systemVersion)
                    Text("System Architecture: " + systemArchitecture)
                }
                VStack
                {
                    
                }
            }
            
            
            Button()
            {
                
            }
            label:
            {
                Image(systemName: "play.circle.fill")
                Text("Senior Review")
                
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
