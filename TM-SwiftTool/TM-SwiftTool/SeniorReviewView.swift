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
    
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: ["Life is a Highway", "No Pomegranates Trap Remix", "Smash Mouth - All Star","The Home Depot Beat", "Old Time Rock N' Roll", "Ball For Me - Post Malone", "Hit Me With Your Best Shot"].randomElement(), withExtension: "mp3", subdirectory: "Songs")!)
    @State var isPlaying = false
    @State private var adminPassword = ""
    @State var seniorReview = SeniorReview()
    @State var isPerformingSeniorReview = false
    @State var disableSeniorReviewButton = false
    @State private var results: [String: String] = [:]
    
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
                .padding([.leading, .trailing])
            
            SecureField("Password", text: $adminPassword).keyboardShortcut(.return).onSubmit
            {
                isPerformingSeniorReview = true
                disableSeniorReviewButton = true
                results = [:]
                
                DispatchQueue.global(qos: .userInitiated).async
                {
                    results = seniorReview.start(AdminPassword: adminPassword)
                    
                    DispatchQueue.main.async
                    {
                        isPlaying = true
                        audioPlayer.play()
                        adminPassword = ""
                        isPerformingSeniorReview = false
                        disableSeniorReviewButton = false
                    }
                }
                
            }
            .padding([.leading, .trailing], 100)
            
            HStack
            {
                Button(action: {
                    
                    isPerformingSeniorReview = true
                    disableSeniorReviewButton = true
                    results = [:]
                    
                    DispatchQueue.global(qos: .userInitiated).async
                    {
                        
                        results = seniorReview.start(AdminPassword: adminPassword)
                        
                        DispatchQueue.main.async
                        {
                            isPlaying = true
                            audioPlayer.play()
                            adminPassword = ""
                            isPerformingSeniorReview = false
                            disableSeniorReviewButton = false
                        }
                    }
                    
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
                    Text(results["munkiUpdates"] ?? "")
                    Text(results["jumpClient"] ?? "")
                    Text(results["sentinelOne"] ?? "")
                    Text(results["rapid7"] ?? "")
                    Text(results["office2021"] ?? "")
                    Text(results["alertusDesktopApp"] ?? "")
                    
                }
                .padding()
            }
        }
        
    }
}
