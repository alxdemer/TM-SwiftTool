//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import LocalAuthentication

struct MainView: View{
    
    var body: some View{
        
        HStack{
            Image("Logo")
                .clipShape(.rect(cornerRadius: 8))
            Text("TM")
                .font(.system(size: 50))
                .bold()
                .foregroundStyle(.linearGradient(colors: [Color(NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), Color(NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0))], startPoint: .top, endPoint: .bottom))
            Text("SwiftTool")
                .font(.system(size: 50))
                .bold()
                .foregroundStyle(.linearGradient(colors: [Color(NSColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0)), Color(NSColor(red: 0.9, green: 0.3, blue: 0.0, alpha: 1.0))], startPoint: .top, endPoint: .bottom))
            
        }
        
        InfoView()
            .padding()
        
        TabView{
            
            SeniorReviewView()
                .tabItem{
                    Label("Senior Review", systemImage: "checkmark.circle")
                }
            AddUserView()
                .tabItem{
                Label("Add User", systemImage: "person.crop.circle.badge.plus")
            }
            ScriptsView()
                .tabItem {
                Label("Scripts", systemImage: "applescript")
            }
            
        }
        .presentedWindowToolbarStyle(.automatic)
        
        VStack{
            
            Text("Version 2.0")
            Text("© 2024 RIT ITS")
            HStack{
                
                Text("Contributors: ")
                    .bold()
                Text("Alex Demerjian")
            }
            .padding(25)
            
        }
        .padding()
        
    }
    
}
