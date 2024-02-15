//
//  AdminPasswordManager.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation

public class AdminPasswordManager{
    
    public static let shared = AdminPasswordManager()
    
    /// Stores the provided admin password into keychain.
    ///
    /// - Throws: AdminPasswordManagerError if failed to add the admin password to keychain.
    public func addToKeychain(adminPassword: String) throws {
        
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
        guard status == errSecSuccess else {throw AdminPasswordManagerError.failedToAddItem}
        
    }

    /// Attemps to get the admin password from keychain.
    ///
    /// - Throws: AdminPasswordManagerError if failed to get the admin password from keychain.
    public func getFromKeychain() throws -> String {
        
        // Define query parameters
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ResLab.TM-SwiftTool",
            kSecAttrAccount as String: NSUserName(),
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Check if item was retrieved successfully
        guard status == errSecSuccess else {throw AdminPasswordManagerError.failedToRetrieveItem}
        
        // Extract password from Keychain data
        guard let keychainItem = item as? [String: Any], let passwordData = keychainItem[kSecValueData as String] as? Data, let password = String(data: passwordData, encoding: .utf8) else {throw AdminPasswordManagerError.failedToExtractAdminPassword}
        
        return password
    }

    /// Deletes the admin password from keychain.
    ///
    /// - Throws: AdminPasswordManagerError if failed to delete the password from keychain.
    public func deleteFromKeychain() throws{
        
        //define query parameters
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ResLab.TM-SwiftTool",
            kSecAttrAccount as String: NSUserName()
        ]

        //delete any entries that have the class set to the generic password, service set to the app bundle id, and account set to the current user
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {throw AdminPasswordManagerError.failedToDeleteItem}
        
    }
    
    /// Verifies that the admin password provided is correct.
    ///
    /// - Returns: Bool indicating if the provided admin password is correct.
    /// - Throws: AdminPasswordManagerError if failed to get the admin password from keychain to verify it.
    public func verifyAdminPassword() throws -> Bool{
        
        let adminPasswordResponse = try sudoShell(command: "-i", argument: "", password: AdminPasswordManager.shared.getFromKeychain())
            
        if adminPasswordResponse.contains("Password:Sorry, try again."){
            return false
        }else{
            return true
        }
        
    }
    
}
