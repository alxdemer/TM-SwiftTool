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
    @State var addUserResult = ""
    
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
            
            TextField("New Username", text: $newUserName)
                .padding([.leading, .trailing], 100)
            
            SecureField("Password", text: $adminPassword)
                .padding([.leading, .trailing], 100)
            
            HStack
            {
                Button(action: {
                    
                    addUserResult = ""
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        
                        //run the shell script to add the new user
                        sudoShellCreateNewUser(command: "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", password: adminPassword, newUserName: newUserName)
                        
                        //check if the new user was added
                        let userAdded = shell("dscl . -list /Users").contains(newUserName)
                        
                        //let the user know if the new user was added
                        DispatchQueue.main.async {
                            if userAdded
                            {
                                addUserResult = "Successfully added user!"
                                adminPassword = ""
                                newUserName = ""
                            }
                            else
                            {
                                addUserResult = "Failed to add user!"
                                adminPassword = ""
                                newUserName = ""
                            }
                        }
                    }
                    
                }, label: {Text("Add")})
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            
            Text(addUserResult)
                .padding()
            
        }
        
    }
}

