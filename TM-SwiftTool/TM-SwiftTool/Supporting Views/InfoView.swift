//
//  InfoView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI

struct InfoView: View{
    
    @StateObject var model = InfoViewModel()
    
    var body: some View{
        
        VStack{
            //dispay headers for system info column and hardware info column
            HStack{
                HStack{
                    
                    Image(systemName: "gearshape.2.fill")
                    Text("System Info")
                        .underline()
                        .font(.system(size: 15, weight: .bold))
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack{
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
            HStack{
                
                VStack{
                    
                    HStack{
                        Text("Hostname: ")
                            .bold()
                        Text(model.hostName ?? "Unknown")
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    HStack{
                        Text("Username: ")
                            .bold()
                        Text(model.currentUser ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    HStack{
                        Text("MacOS: ")
                            .bold()
                        Text(model.osVersion ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    HStack{
                        Text("Model: ")
                            .bold()
                        Text(model.model?.description ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                }
                
                VStack{
                    
                    HStack{
                        Text("Serial: ")
                            .bold()
                        Text(model.serialNumber ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    
                    HStack{
                        Text("Processor: ")
                            .bold()
                        Text(model.processor ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    HStack{
                        Text("RAM: ")
                            .bold()
                        Text(model.ramInfo ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                    HStack{
                        Text("HDD/SSD: ")
                            .bold()
                        Text(model.storageInfo ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 5)
                    
                }
            }
            
        }
        .padding([.leading, .trailing])
    }
}



