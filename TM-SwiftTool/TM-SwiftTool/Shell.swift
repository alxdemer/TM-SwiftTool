//
//  Shell.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 1/17/23.
//

import Foundation
import ServiceManagement

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/sh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    
    return output
}

func sudoShell(_ command: String, password: String) -> String {
    
    let taskOne = Process()
        taskOne.launchPath = "/bin/echo"
        taskOne.arguments = [password]

        let taskTwo = Process()
        taskTwo.launchPath = "/usr/bin/sudo"
        taskTwo.arguments = ["-S", "/usr/local/munki/managedsoftwareupdate", "--checkonly"]

        let pipeBetween:Pipe = Pipe()
        taskOne.standardOutput = pipeBetween
        taskTwo.standardInput = pipeBetween

        let pipeToMe = Pipe()
        taskTwo.standardOutput = pipeToMe
        taskTwo.standardError = pipeToMe

        taskOne.launch()
        taskTwo.launch()

        let data = pipeToMe.fileHandleForReading.readDataToEndOfFile()
        let output : String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    return output
}
