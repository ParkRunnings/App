//
//  MainProgressElement.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/6/2022.
//

import SwiftUI

struct MainTimeProgress: View {
    
    @Binding var progress: Double
    @Binding var start: String
    
    var body: some View {
        
        ZStack(alignment: .leading, content: {
            
            ProgressCircleElement(progress: $progress, colour: Colour(hex: "#E62E6B"), line: 7)
                .frame(width: 36, height: 36)
                .padding(.leading, 22)
            
            VStack(alignment: .leading, spacing: -2, content: {
                ProgressTextElement(text: "SAT", colour: "#858585")
                ProgressTextElement(text: start)
            })
            
        })
        
        
        
    }

}

struct MainDistanceProgress: View {
    
    @Binding var progress: Double
    @Binding var distance: String
    
    var body: some View {
        
        ZStack(alignment: .leading, content: {
            
            ProgressCircleElement(progress: $progress, colour: Colour(hex: "#23CF54"), line: 7)
                .frame(width: 36, height: 36)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 0, content: {
                ProgressTextElement(text: distance)
                ProgressTextElement(text: "KM", colour: "#858585")
                
            })
            
        })
        
    }

}

struct MainProgressElement_Previews: PreviewProvider {
    static var previews: some View {
        MainTimeProgress(progress: .constant(0.73), start: .constant("08:30"))
        MainDistanceProgress(progress: .constant(0.1), distance: .constant("14.2"))
    }
}
