//
//  TMSwiftToolProgressView.swift
//  TM-SwiftTool
//
//  Created by Alex Demerjian on 2/27/24.
//

import SwiftUI

struct LoadingView: View {
    
    @State var progressViewTitle: String
    
    var body: some View {
        HStack{
            ProgressView(progressViewTitle)
                .foregroundColor(.black)
                .progressViewStyle(.circular)
        }
        .padding()
        .background(.gray)
        .clipShape(.rect(cornerRadius: 8))
    }
}
