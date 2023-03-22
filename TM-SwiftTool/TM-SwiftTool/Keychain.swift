//
//  Keychain.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 3/21/23.
//

import Foundation
import Security
import LocalAuthentication

//adds the adminPassword to keychain and stores it in the secure enclave
func addToKeychain(adminPassword: String) -> Bool
{
    
    //create local authorization context
    let context = LAContext()
    
    //allow the user to authenticate if necessary
    context.interactionNotAllowed = false
    
    //create a variable to hold the error
    var error: NSError?
    
    //determine if the context can be authenticated
    let contextAuthenticationSuccessful = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)

    //if it can be then continue
    if contextAuthenticationSuccessful
    {
        
        
        // Define query parameters
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ResLab.TM-SwiftTool",
            kSecAttrAccount as String: NSUserName(),
            kSecUseAuthenticationContext as String: context,
            kSecValueData as String: adminPassword.data(using: .utf8)!
        ]
        
        // Add item to keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        
        // Check if item was added successfully
        print("Result of adding keychain: " + status.description)
        if status != errSecSuccess {
            return false
        }
        
        return true
    }
    else
    {
        return false
    }
    
    
}

//gets the adminPassword from the secure enclave via keychain
func getFromKeychain() -> String? {
    
    // Define query parameters
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "ResLab.TM-SwiftTool",
        kSecAttrAccount as String: NSUserName(),
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ]
    
    // Retrieve item from keychain
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    // Check if item was retrieved successfully
    guard status == errSecSuccess else {
        return nil
    }
    
    // Extract password from keychain data
    guard let keychainItem = item as? [String: Any],
          let passwordData = keychainItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: .utf8)
    else {
        return nil
    }
    
    return password
}

//deletes the adminPassword from the secure enclave via keychain
func deleteFromKeychain()
{
    //define query parameters
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "ResLab.TM-SwiftTool",
        kSecAttrAccount as String: NSUserName()
    ]

    //delete any entries that have the class set the generic password, service set to the app bundle id, and account set to the current user
    SecItemDelete(query as CFDictionary)
}



