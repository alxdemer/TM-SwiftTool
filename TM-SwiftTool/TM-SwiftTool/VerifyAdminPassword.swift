//
//  VerifyAdminPassword.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 3/22/23.
//

import Foundation

//function to verify that the adminPassword provided is correct
func VerifyAdminPassword() -> Bool
{
    let adminPasswordResponse = sudoShell(command: "-i", argument: "", password: getFromKeychain()!)
    
    if adminPasswordResponse.contains("Password:Sorry, try again.")
    {
        return false
    }
    
    return true
}
