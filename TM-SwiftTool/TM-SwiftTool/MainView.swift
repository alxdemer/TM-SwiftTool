//
//  ContentView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI
import LocalAuthentication

struct MainView: View
{
    
    var body: some View
    {
        
        TabView
        {
            InfoView()
                .tabItem
                {
                    Label("Information", systemImage: "info.circle")
                
                }
            
            SeniorReviewView()
                .tabItem {
                    Label("Senior Review", systemImage: "checkmark.circle")
                }
            AddUserView()
                .tabItem
            {
                Label("Add User", systemImage: "person.crop.circle.badge.plus")
            }
            
            
        }
        .presentedWindowToolbarStyle(.expanded)
        
        
    }
    
}

