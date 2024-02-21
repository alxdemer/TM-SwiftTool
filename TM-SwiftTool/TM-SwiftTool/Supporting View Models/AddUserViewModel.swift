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
        
        //set is adding user to true
        DispatchQueue.main.async{
            self.isAddingUser = true
        }
        
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
            DispatchQueue.main.async{
                self.adminPassword = ""
            }
            
            //verify that the admin password they provided is correct
            guard try adminPasswordManager.verifyAdminPassword() == true else{
                
                DispatchQueue.main.async{
                    self.alertMessage = "Incorrect admin password. Please try again."
                    self.showAlert = true
                    self.isAddingUser = false
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
            
            //create the new user folder
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)", password: adminPassword)
            
            //add essential folders/directories in new user folder
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Library", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Desktop", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Documents", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Downloads", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Movies", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Music", password: adminPassword)
            let _ = sudoShell(command: "mkdir", argument: "/Users/\(newUserName)/Pictures", password: adminPassword)
            
            //check if the new user was added
            let users = shell("ls /Users")
            
            //let the user know if the new user was added
            DispatchQueue.main.async {
                
                if users.contains(self.newUserName){
                    
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
            
            //set the alert message to the error description and show the alert
            DispatchQueue.main.async{
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
            return
            
        }
        
    }
}
