//
//  ScriptsView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/27/24.
//

import SwiftUI

struct ScriptsView: View {
    @State var isLoading = false
    @State var showAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        
        ZStack{
            
            VStack{
                Button{
                    self.isLoading = true
                    
                    do{
                        try RootCMDHelperClient.shared.jamfSyncPolicies()
                    }catch{
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                    
                    self.isLoading = false
                    
                }label:{
                    
                    HStack{
                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                        Text("Sync Policies")
                    }
                    
                }
                
                Button{
                    self.isLoading = true
                    do{
                        try RootCMDHelperClient.shared.jamfReportInventory()
                    }catch{
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                    self.isLoading = false
                }label:{
                    
                    HStack{
                        Image(systemName: "arrow.up.bin")
                        Text("Report Inventory")
                    }
                    
                }
                
            }
            
            if isLoading{
                LoadingView(progressViewTitle: "Running Script...")
            }
            
        }
        .alert(alertMessage, isPresented: $showAlert){
            
            Button(){
                showAlert = false
                alertMessage = ""
            }label:{
                Text("OK")
            }
            .padding()
            
        }
        
    }
}

#Preview {
    ScriptsView()
}
