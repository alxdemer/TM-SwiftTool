//
//  AddUserViewModel.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation

public class AddUserViewModel: ObservableObject{
    
    @Published var adminPasswordManager = AdminPasswordManager.shared
    @Published var newUserName = ""
    @Published var adminPassword = ""
    @Published var isAddingUser = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    public func addUser() async{
        
        alertMessage = ""
        isAddingUser = true
        
        do{
            
            //attempt to store the new adminPassword for this user in keychain
            guard adminPasswordManager.storeInKeychain(adminPassword: adminPassword) == true else {
                
                DispatchQueue.main.async{
                    self.alertMessage = AdminPasswordManagerError.failedToStoreAdminPassword.localizedDescription
                    self.showAlert = true
                }
                return
                
            }
            
            //wipe the adminPassword variable
            adminPassword = ""
            
            //verify that the admin password they provided is correct
            guard try adminPasswordManager.verifyAdminPassword() == true else{
                
                DispatchQueue.main.async{
                    self.alertMessage = "Incorrect admin password. Please try again."
                    self.showAlert = true
                }
                return
                
            }
            
            //get the admin password from keychain
            guard let adminPassword = adminPasswordManager.getFromKeychain() else {
                
                DispatchQueue.main.async{
                    self.alertMessage = AdminPasswordManagerError.failedToGetAdminPassword.localizedDescription
                    self.showAlert = true
                }
                return
                
            }
            
            //create the new user
            sudoShellCreateNewUser(command: "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", password: adminPassword, newUserName: newUserName)
            
            //check if the new user was added
            let userAdded = shell("dscl . -list /Users").contains(newUserName)
            
            //let the user know if the new user was added
            DispatchQueue.main.async {
                
                if userAdded{
                    
                    self.newUserName = ""
                    self.alertMessage = "Successfully added user!"
                    self.showAlert = true
                    self.isAddingUser = false
                    
                }else{
                    
                    self.alertMessage = "Failed to add user."
                    self.showAlert = true
                    self.isAddingUser = false
                    
                }
                
            }
            
        }catch{
            DispatchQueue.main.async{
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
            return
        }
        
    }
}
