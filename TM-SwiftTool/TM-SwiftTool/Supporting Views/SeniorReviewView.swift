//
//  SeniorReviewView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian (Student Employee) on 2/16/23.
//

import SwiftUI
import AVFoundation

struct SeniorReviewView: View{
    
    @StateObject var model = SeniorReviewViewModel()
    
    var body: some View{
        
        ZStack{
            
            VStack{
                
                Image(systemName: "checklist")
                    .resizable()
                    .frame(width: 36, height: 30)
                    .padding()
                
                Text("Please press the start button to begin the Senior Review.")
                    .padding([.leading, .trailing], 100)
                
                HStack{
                    
                    Button(action: {
                        
                        Task.init{
                            
                            await model.seniorReview.start()
                        }
                        
                    }, label: {Text("Start")})
                    .disabled(model.disableSeniorReviewButton)
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    if let audioTester = model.seniorReview.audioTester{
                        
                        Button(){
                            
                            if !audioTester.isPlaying{
                                model.isPlaying = true
                                model.seniorReview.startAudioTester()
                                
                            }else{
                                model.isPlaying = false
                                model.seniorReview.stopAudioTester()
                            }
                            
                        }label:{
                            
                            Image(systemName: audioTester.isPlaying ? "stop.circle.fill":"play.circle.fill")
                            Text("Test Audio")
                        }
                        .padding()
                        
                    }
                    
                }

                ScrollView{
                    
                    ForEach(model.seniorReviewResults){
                        seniorReviewResult in
                        
                        Text(seniorReviewResult.description)
                    }
                    
                }
                
            }
            
            if model.isPerformingSeniorReview{
                
                HStack{
                    Text("Performing Senior Review")
                    
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(0.5)
                }
                
            }
            
        }
        .onAppear{
            
            model.seniorReview.delegate = model
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

