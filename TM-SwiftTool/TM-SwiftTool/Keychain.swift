//
//  Keychain.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 3/21/23.
//

import Foundation
import Security

func addToKeychain(adminPassword: String) -> Bool {
    
    // Convert password to data for storage in keychain
    let adminPasswordData = adminPassword.data(using: .utf8)!
    
    // Define query parameters
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "ResLab.TM-SwiftTool",
        kSecAttrAccount as String: NSUserName(),
        kSecValueData as String: adminPasswordData
    ]
    
    // Add item to keychain
    let status = SecItemAdd(query as CFDictionary, nil)
    
    
    // Check if item was added successfully
    if status != errSecSuccess {
        return false
    }
    
    return true
}

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



