//
//  InfoView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI

struct InfoView: View
{
    
    private var computerInfo = ComputerInfo()
    
    var body: some View
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
                        Text(computerInfo.systemHostName)
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    HStack
                    {
                        Text("Username: ")
                            .bold()
                        Text(computerInfo.userName)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    HStack
                    {
                        Text("MacOS: ")
                            .bold()
                        Text(computerInfo.systemVersion)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    HStack
                    {
                        Text("System Architecture: ")
                            .bold()
                        Text(computerInfo.systemArchitecture)
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
                        Text(computerInfo.macModelFinder.getMacModel()!.description)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    HStack
                    {
                        Text("Serial: ")
                            .bold()
                        Text(computerInfo.getMacSerial())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    
                    HStack
                    {
                        Text("Processor: ")
                            .bold()
                        Text(computerInfo.getMacProcessor())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                    HStack
                    {
                        Text("HDD/SSD: ")
                            .bold()
                        Text(computerInfo.getMacSSDHDD())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                    
                }
            }
            
            Divider()
            
            VStack
            {
                Text("© 2023 RIT ITS")
                Text("Beta 4")
            }
            .padding()
            
            
        }
        .padding([.leading, .trailing])
    }
}

