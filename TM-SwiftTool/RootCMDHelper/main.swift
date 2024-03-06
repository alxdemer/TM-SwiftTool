//
//  main.swift
//  RootCMDHelper
//
//  Created by Alex Demerjian on 2/28/24.
//

import Foundation

let listener = NSXPCListener.service()
let service = Functions()

listener.delegate = service
listener.resume()

// Keep the command line tool running to listen for incoming XPC connections
RunLoop.main.run()
