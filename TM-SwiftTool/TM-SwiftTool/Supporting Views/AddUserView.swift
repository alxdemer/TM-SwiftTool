//
//  AddUserView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI

struct AddUserView: View{
    
    @StateObject var model = AddUserViewModel()
    
    var body: some View{
        
        ZStack{
            
            VStack{
                
                HStack{
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .frame(width: 36, height: 30)
                }
                .padding()
                
                Text("Please enter the username for the new user and your admin password.")
                    .padding([.leading, .trailing], 100)
                
                TextField("New Username", text: $model.newUserName)
                    .padding([.leading, .trailing], 100)
                
                SecureField("Your Password", text: $model.adminPassword)
                    .padding([.leading, .trailing], 100)
                    .onSubmit {
                        Task.init(){
                            await model.addUser()
                        }
                    }
                
                HStack{
                    
                    Button(action: {
                        Task.init(){
                            await model.addUser()
                        }
                        
                    }, label: {Text("Add")})
                    .buttonStyle(.borderedProminent)
                    .disabled(model.isAddingUser)
                    .padding()
                }
                
            }
            
            if model.isAddingUser{
                
                HStack{
                    ProgressView("Adding New User")
                        .foregroundColor(.black)
                        .progressViewStyle(.circular)
                }
                .padding()
                .background(Color(NSColor(red: 0.9, green: 0.5, blue: 0.01, alpha: 0.5)))
                .clipShape(.rect(cornerRadius: 8))
                
            }
            
        }
        .alert(model.alertMessage, isPresented: $model.showAlert){
            
            Button(){
                model.showAlert = false
                model.alertMessage = ""
            }label:{
                Text("OK")
            }
            .padding()
            
        }
        
    }
}
