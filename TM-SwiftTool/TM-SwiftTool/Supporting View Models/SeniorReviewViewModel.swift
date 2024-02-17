//
//  SeniorReviewViewModel.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/13/24.
//

import Foundation
import SwiftUI

public class SeniorReviewViewModel: ObservableObject, SeniorReviewDelegate{

    let seniorReview = SeniorReview()
    @Published var seniorReviewResults: [SeniorReviewResult] = []
    @Published var isPlaying = false
    @Published var isPerformingSeniorReview = false
    @Published var disableButtons = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    public func startSeniorReview() async{
        DispatchQueue.main.async{
            self.disableButtons = true
            self.isPerformingSeniorReview = true
        }
        await seniorReview.start()
    }
    
    public func seniorReviewComplete(seniorReviewResults: [SeniorReviewResult]) {
        DispatchQueue.main.async{
            self.disableButtons = false
            self.isPerformingSeniorReview = false
            self.seniorReviewResults = seniorReviewResults
        }
    }
    
    public func audioTesterError(error: Error) {
        DispatchQueue.main.async {
            self.alertMessage = error.localizedDescription
            self.showAlert = true
        }
    }
    
    public func audioTesterStarted() {
        DispatchQueue.main.async{
            self.isPlaying = true
        }
    }
    
    public func audioTesterStopped() {
        DispatchQueue.main.async{
            self.isPlaying = false
        }
    }
    
    
}
