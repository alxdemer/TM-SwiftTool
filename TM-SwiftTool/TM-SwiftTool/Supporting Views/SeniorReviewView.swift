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
                
                ScrollView{
                
                    Image(systemName: "checklist")
                        .resizable()
                        .frame(width: 36, height: 30)
                        .padding()
                    
                    Text("Please press the start button to begin the Senior Review.")
                        .padding([.leading, .trailing], 100)
                    
                    HStack{
                        
                        Button(action: {
                            Task.init{
                                await model.startSeniorReview()
                            }
                            
                        }, label: {Text("Start")})
                        .disabled(model.disableButtons)
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
                            .disabled(model.disableButtons)
                            .padding()
                            
                        }
                        
                    }
                    
                    ForEach(model.seniorReviewResults){
                        seniorReviewResult in
                        
                        switch seniorReviewResult{
                        case .success:
                            Text(seniorReviewResult.description)
                                .foregroundStyle(.green)
                        case .failure:
                            Text(seniorReviewResult.description)
                                .foregroundStyle(.red)
                        }
                        
                    }
                    
                }
                .frame(minWidth: 200)
                
            }
            
            if model.isPerformingSeniorReview{
                HStack{
                    ProgressView("Performing Senior Review")
                        .foregroundColor(.black)
                        .progressViewStyle(.circular)
                }
                .padding()
                .background(.gray)
                .clipShape(.rect(cornerRadius: 8))
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

