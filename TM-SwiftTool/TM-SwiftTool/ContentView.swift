//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI

struct ContentView: View {
    
    //get computer hostname
    let currentHost = Host.current().localizedName ?? ""
    let userName = NSUserName()
    var systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
    //var systemType = ProcessInfo.processInfo.
    
    var body: some View {
        VStack {
            
            HStack
            {
                Text("System Info:")
                    .underline()
                    .padding()
                
                Text("Hardware Info:")
                    .underline()
                    .padding()
            }
            .padding()
            
            HStack
            {
                VStack
                {
                    Text("Hostname: " + currentHost)
                    Text("Username: " + userName)
                    Text("MacOS: " + systemVersion)
                    //Text("System Type: " + systemType)
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
