//
//  MainProgressElement.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/6/2022.
//

import SwiftUI

struct MainTimeProgress: View {
    
    @EnvironmentObject var design: DesignController
    
    @Binding var progress: Double
    @Binding var start: String
    
    var body: some View {
        
        ZStack(alignment: .leading, content: {
            
            ProgressCircleElement(progress: $progress, colour: Colour(hex: "#E62E6B"), line: design.size(size: .progress_circle_line))
                .frame(width: design.size(size: .progress_circle_size), height: design.size(size: .progress_circle_size))
                .padding(.leading, design.size(size: .progress_time_leading))
            
            VStack(alignment: .leading, spacing: -2, content: {
                ProgressTextElement(text: "SAT", colour: "#858585")
                ProgressTextElement(text: start)
            })
            
        })
        
        
        
    }

}

struct MainDistanceProgress: View {
    
    @EnvironmentObject var design: DesignController
    
    @Binding var progress: Double
    @Binding var distance: String
    
    var body: some View {
        
        ZStack(alignment: .leading, content: {
            
            ProgressCircleElement(progress: $progress, colour: Colour(hex: "#23CF54"), line: design.size(size: .progress_circle_line))
                .frame(width: design.size(size: .progress_circle_size), height: design.size(size: .progress_circle_size))
                .padding(.leading, design.size(size: .progress_distance_leading))
            
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
