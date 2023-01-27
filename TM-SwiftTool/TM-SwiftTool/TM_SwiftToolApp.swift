//
//  TM_SwiftToolApp.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 10/19/22.
//

import SwiftUI

@main
struct TM_SwiftToolApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: 600, maxWidth: 800, minHeight: 400, maxHeight: .infinity)
        }
        
    }
}
