//
//  Keychain.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 3/21/23.
//

import Foundation
import Security
import LocalAuthentication

//adds the adminPassword to Keychain
func addToKeychain(adminPassword: String) -> Bool
{
    
    // Define query parameters
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "ResLab.TM-SwiftTool",
        kSecAttrAccount as String: NSUserName(),
        kSecValueData as String: adminPassword.data(using: .utf8)!
    ]
    
    // Add item to Keychain
    let status = SecItemAdd(query as CFDictionary, nil)
    
    
    // Check if item was added successfully
    if status != errSecSuccess {
        return false
    }
    
    return true
}

//gets the adminPassword from Keychain
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
    
    // Retrieve item from Keychain
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    // Check if item was retrieved successfully
    guard status == errSecSuccess else {
        return nil
    }
    
    // Extract password from Keychain data
    guard let keychainItem = item as? [String: Any],
          let passwordData = keychainItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: .utf8)
    else {
        return nil
    }
    
    return password
}

//deletes the adminPassword from Keychain
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



