//
//  Shell.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation
import ServiceManagement

/// Runs the provided command
public func shell(_ command: String) -> String{
    
    //create a process and a pipe
    let task = Process()
    
    //create a pipe to handle output
    let pipe = Pipe()
    
    //set the standard output and standard error to the pipe
    task.standardOutput = pipe
    task.standardError = pipe
    
    //set the arguments with the corresponding command
    task.arguments = ["-c", command]
    
    //set the launch path for the process at "/bin/zsh"
    task.launchPath = "/bin/zsh"
    
    //set standard input to nil
    task.standardInput = nil
    
    //launch the process
    task.launch()
    
    //set data to the output from the pipe
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    //convert the data to a string
    let output = String(data: data, encoding: .utf8)!
    
    //return the string
    return output
    
}

public func sudoShell(command: String, argument: String, password: String) -> String {
        
        let taskOne = Process()
        taskOne.launchPath = "/bin/echo"
        taskOne.arguments = [password]

        let taskTwo = Process()
        taskTwo.launchPath = "/usr/bin/sudo"
        taskTwo.arguments = ["-k", "-S", command, argument]

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


