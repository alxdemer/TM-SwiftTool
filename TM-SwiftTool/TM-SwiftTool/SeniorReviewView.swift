//
//  SeniorReviewView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI
import AVFoundation

struct SeniorReviewView: View
{
    
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: ["Life is a Highway", "No Pomegranates Trap Remix", "Smash Mouth - All Star","The Home Depot Beat", "Old Time Rock N' Roll", "Ball For Me - Post Malone", "Hit Me With Your Best Shot", "You Make Me Feel", "92 Explorer", "Goosebumps"].randomElement(), withExtension: "mp3", subdirectory: "Songs")!)
    @State var isPlaying = false
    @State private var adminPassword = ""
    @State var userMessage = ""
    @State var seniorReview = SeniorReview()
    @State var isPerformingSeniorReview = false
    @State var disableSeniorReviewButton = false
    @State var results: [String: String] = [:]
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Senior Review")
                    .font(.largeTitle)
            }
            .padding()
            
            
            Text("Please enter your admin password:")
                .padding([.leading, .trailing, .bottom])
            
            Text(userMessage).foregroundColor(.red)
            
            SecureField("Your Password", text: $adminPassword).keyboardShortcut(.return).onSubmit
            {
                startSeniorReviewProcess()
            }
            .padding([.leading, .trailing], 100)
            
            HStack
            {
                Button(action: {
                    
                    startSeniorReviewProcess()
                    
                }, label: {Text("Start")})
                .disabled(disableSeniorReviewButton)
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button()
                {
                    
                    if (!audioPlayer.isPlaying)
                    {
                        isPlaying = true
                        audioPlayer.play()
                        shell("osascript -e \"set Volume 3\"")
                    }
                    else
                    {
                        isPlaying = false
                        audioPlayer.stop()
                    }
                     
                }
                label:
                {
                    
                    Image(systemName: isPlaying ? "stop.circle.fill":"play.circle.fill")
                    Text("Test Audio")
                    
                }
                .padding()
                
            }
            
            
            HStack
            {
                if isPerformingSeniorReview == true
                {
                    Text("Performing Senior Review")
                    
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(0.5)
                }
            }
            .padding()
            
            HStack
            {
                VStack
                {
                    if (results["munkiUpdates"] != "")
                    {
                        Text(results["munkiUpdates"] ?? "")
                    }
                    
                    if (results["jumpClient"] != "")
                    {
                        Text(results["jumpClient"] ?? "")
                    }
                    
                    if (results["sentinelOne"] != "")
                    {
                        Text(results["sentinelOne"] ?? "")
                    }
                    
                    if (results["rapid7"] != "")
                    {
                        Text(results["rapid7"] ?? "")
                    }
                    
                    if (results["office2021"] != "")
                    {
                        Text(results["office2021"] ?? "")
                    }
                    
                    if (results["alertusDesktopApp"] != "")
                    {
                        Text(results["alertusDesktopApp"] ?? "")
                    }
                    
                    if (results["driveSmartStatus"] != "")
                    {
                        Text(results["driveSmartStatus"] ?? "")
                    }
                    
                    if (results["batteryCapacity"] != "")
                    {
                        Text(results["batteryCapacity"] ?? "")
                    }
                    
                }
                .padding()
            }
        }
        
    }
    
    func startSeniorReviewProcess()
    {
        isPerformingSeniorReview = true
        disableSeniorReviewButton = true
        
        //clear any past results
        results = [:]
        
        //clear any user message
        userMessage = ""
        
        //throw process on background thread
        DispatchQueue.global(qos: .userInitiated).async
        {
            
            //just in case TM-SwiftTool already has any adminPassword saved for this user in keychain, delete it
            deleteFromKeychain()
            
            //attempt to add the new adminPassword for this user in keychain and get the result
            let addedToKeychain = addToKeychain(adminPassword: adminPassword)
            
            //wipe the adminPassword variable
            adminPassword = ""
            
            //if the adminPassword is in keychain successfully, continue with Senior Review
            if addedToKeychain
            {
                
                //if the admin password is not correct, do not start Senior Review, and delete the adminPassword from keychain
                if seniorReview.verifyAdminPassword() == false
                {
                    deleteFromKeychain()
    
                    //throw process on main thread and update view
                    DispatchQueue.main.async
                    {
                        isPerformingSeniorReview = false
                        disableSeniorReviewButton = false
                        userMessage = "Incorrect admin password. Please try again."
                    }
                }
                //if the admin password is correct, perform Senior Review
                else
                {
                    results = seniorReview.start()
                    
                    shell("osascript -e \"set Volume 3\"")
                    audioPlayer.play()
                    
                    //throw process on main thread and update view
                    DispatchQueue.main.async
                    {
                        isPlaying = true
                        isPerformingSeniorReview = false
                        disableSeniorReviewButton = false
                    }
                }
            }
            //if the admin password could not be added to keychain, do not perform Senior Review and let the user know the problem
            else
            {
                
                //throw process on main thread to update view
                DispatchQueue.main.async
                {
                    isPerformingSeniorReview = false
                    disableSeniorReviewButton = false
                    userMessage = "An issue occurred storing the admin password. Please try again."
                }
            }
            
        }
    }
}
