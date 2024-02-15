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
            //just in case there is already any adminPassword saved for this user in keychain, delete it
            try adminPasswordManager.deleteFromKeychain()
            
            //attempt to add the new adminPassword for this user in keychain and get the result
            try adminPasswordManager.addToKeychain(adminPassword: adminPassword)
            
            //wipe the adminPassword variable
            adminPassword = ""
            
            //try to verify that the admin password provided is valid
            if try adminPasswordManager.verifyAdminPassword(){
                
                //try to create the new user
                try sudoShellCreateNewUser(command: "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", password: adminPasswordManager.getFromKeychain(), newUserName: newUserName)
                
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
                
                
            }else{
                
                do{
                    try adminPasswordManager.deleteFromKeychain()
                }catch{
                    print("An error occured when deleting the incorrect admin password from keychain. \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async{
                    self.alertMessage = "Incorrect admin password. Please try again."
                    self.showAlert = true
                }
                return
                
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
