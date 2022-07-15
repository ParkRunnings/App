//
//  ProfileElements.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/5/2022.
//

import SwiftUI

struct ProfileStat: View {
    
    let stat: String
    let value: String
    
    var body: some View {
        
        HStack(alignment: .center, content: {
            
            HeadingTextElement(text: stat)
                .opacity(0.6)
            
            Spacer()
            
            AthleteNumberTextElement(text: value)
                
            
        })
        
    }
    
}
