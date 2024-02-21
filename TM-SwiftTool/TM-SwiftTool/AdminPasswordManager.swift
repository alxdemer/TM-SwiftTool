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
    /// - If the keychain item already exists, it will check to verify that the value matches the admin password provided. If it does, it will return true. Otherwise, it will update the value
    /// - If the keychain item does not already exists, it will create it and set the value to the admin password provided
    ///
    /// - Returns: Bool indicating if the admin password is stored in keychain.
    public func storeInKeychain(adminPassword: String) -> Bool {
        
        //check if there is already an entry in keychain
        if let storedAdminPassword = getFromKeychain(){
            
            //if the entry contains a value equal to the new admin password, return true
            if storedAdminPassword == adminPassword{
                
                return true
                
            //if it is not equal to the new admin password, update it
            }else{
                
                //define the existing keychain item attributes
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrService as String: "ResLab.TM-SwiftTool",
                    kSecAttrAccount as String: NSUserName(),
                    kSecMatchLimit as String: kSecMatchLimitOne,
                    kSecReturnAttributes as String: true,
                    kSecReturnData as String: true
                ]
                
                //define the attributes to update
                let attributesToUpdate: [String: Any] = [
                    kSecValueData as String: adminPassword.data(using: .utf8)!
                ]
                
                //update the value of the key
                let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
                
                if status == errSecSuccess {
                    print("Keychain item updated.")
                    return true
                } else {
                    print("Error updating keychain item: \(status)")
                    return false
                }
                
            }
            
        //otherwise create a new entry in keychain and store the new admin password in it
        }else{
            
            // Define query parameters
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: "ResLab.TM-SwiftTool",
                kSecAttrAccount as String: NSUserName(),
                kSecValueData as String: adminPassword.data(using: .utf8)!
            ]
            
            // Add item to Keychain
            let status = SecItemAdd(query as CFDictionary, nil)
            
            // return if admin password was stored successfully
            if status == errSecSuccess{
                print("Added to keychain.")
                return true
            }else{
                print("Failed to add to keychain: \(status)")
                return false
            }
            
        }
        
    }
    
    /// Attemps to get the admin password from keychain.
    ///
    /// - Returns: String representation of the password. Nil if the password does not exist in keychain or if failled to retrieve the password.
    public func getFromKeychain() -> String? {
        
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
        guard status == errSecSuccess else {return nil}
        
        // Extract password from Keychain data
        guard let keychainItem = item as? [String: Any], let passwordData = keychainItem[kSecValueData as String] as? Data, let password = String(data: passwordData, encoding: .utf8) else {return nil}
        
        return password
    }

    /// Removes the admin password from keychain.
    ///
    /// - Returns: Bool indicating if the admin password is removed from keychain.
    public func removeFromKeychain() -> Bool{
        
        //check if there is an admin password stored in keychain
        guard let _ = getFromKeychain() else {return true}
        
        //define query parameters
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ResLab.TM-SwiftTool",
            kSecAttrAccount as String: NSUserName(),
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        //delete any entries that have the class set to the generic password, service set to the app bundle id, and account set to the current user
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess{
            return true
        }else{
            return false
        }
        
    }
    
    /// Verifies that the stored admin password provided is correct.
    ///
    /// - Returns: Bool indicating if the provided admin password is correct.
    /// - Throws: AdminPasswordManagerError if there is no admin password stored in keychain.
    public func verifyAdminPassword() throws -> Bool{
        
        guard let storedAdminPassword = getFromKeychain() else {
            throw AdminPasswordManagerError.noAdminPasswordStoredInKeychain
        }
        
        let adminPasswordResponse = sudoShell(command: "-i", argument: "", password: storedAdminPassword)
            
        if adminPasswordResponse.contains("Password:Sorry, try again."){
            return false
        }else{
            return true
        }
        
    }
    
}
