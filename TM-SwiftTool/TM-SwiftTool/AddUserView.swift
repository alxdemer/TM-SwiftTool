//
//  AddUserView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI

struct AddUserView: View
{
    @State var newUserName = ""
    @State private var adminPassword = ""
    @State var isAddingUser = false
    @State var userMessage = ""
    @State var userMessageColor = Color.black
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 36, height: 30)
                Text("Add User")
                    .font(.largeTitle)
            }
            .padding()
            
            
            Text("Please enter the username for the new user and your admin password:")
                .padding([.leading, .trailing], 100)
            
            Text(userMessage)
                .foregroundColor(userMessageColor)
                .padding()
            
            TextField("New Username", text: $newUserName)
                .padding([.leading, .trailing], 100)
            
            SecureField("Your Password", text: $adminPassword)
                .padding([.leading, .trailing], 100)
            
            HStack
            {
                Button(action: {
                    
                    userMessage = ""
                    isAddingUser = true
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        
                        //just in case TM-SwiftTool already has any adminPassword saved for this user in keychain, delete it
                        deleteFromKeychain()
                        
                        //attempt to add the new adminPassword for this user in keychain and get the result
                        let addedToKeychain = addToKeychain(adminPassword: adminPassword)
                        
                        //wipe the adminPassword variable
                        adminPassword = ""
                        
                        if addedToKeychain
                        {
                            if !VerifyAdminPassword()
                            {
                                deleteFromKeychain()
                
                                //throw process on main thread and update view
                                DispatchQueue.main.async
                                {
                                    userMessageColor = .red
                                    userMessage = "Incorrect admin password. Please try again."
                                    newUserName = ""
                                    isAddingUser = false
                                }
                            }
                            else
                            {
                                //run the shell script to add the new user
                                sudoShellCreateNewUser(command: "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", password: getFromKeychain()!, newUserName: newUserName)
                                
                                //check if the new user was added
                                let userAdded = shell("dscl . -list /Users").contains(newUserName)
                                
                                //let the user know if the new user was added
                                DispatchQueue.main.async {
                                    if userAdded
                                    {
                                        userMessageColor = .green
                                        userMessage = "Successfully added user!"
                                        newUserName = ""
                                        isAddingUser = false
                                    }
                                    else
                                    {
                                        userMessageColor = .red
                                        userMessage = "Failed to add user."
                                        newUserName = ""
                                        isAddingUser = false
                                    }
                                }
                            }
                        }
                        else
                        {
                            deleteFromKeychain()
            
                            //throw process on main thread and update view
                            DispatchQueue.main.async
                            {
                                userMessageColor = .red
                                userMessage = "An issue occurred storing the admin password. Please try again."
                                newUserName = ""
                                isAddingUser = false
                            }
                        }
                        
                        
                    }
                    
                }, label: {Text("Add")})
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            HStack
            {
                if isAddingUser == true
                {
                    Text("Adding User")
                    
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(0.5)
                }
            }
            .padding()
            
            
        }
        
    }
}

