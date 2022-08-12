//
//  ProgressElements.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 8/6/2022.
//

import SwiftUI


struct ProgressCircleElement: View {
    
    @Binding var progress: Double
    
    let colour: Colour
    let line: CGFloat
    private let dark_colour: Colour
    
    private let gradient_a: Gradient
    private let gradient_b: Gradient
    
    init(progress: Binding<Double>, colour: Colour, line: CGFloat = 30) {
        
        self._progress = progress
        
        self.colour = colour
        self.line = line
        self.dark_colour = colour.darken(percentage: 0.2)
        
        self.gradient_a = Gradient(colors: Array(repeating: self.dark_colour, count: 2) + Array(repeating: self.colour, count: 4) + Array(repeating: self.dark_colour, count: 2))
        self.gradient_b = Gradient(colors: Array(repeating: self.dark_colour, count: 2) + Array(repeating: self.colour, count: 6))

    }
    
//    var colour: Colour = Colour(hex: "#E62E6B") Colour(hex: "#BD1F4E")
    
    var body: some View {
   
        ZStack(alignment: .center, content: {
         
            Circle()
                .stroke(colour.opacity(0.3), lineWidth: line)
        
            Circle()
                .trim(from: 0, to: 0.001)
                .stroke(
                    dark_colour, style: StrokeStyle(lineWidth: line, lineCap: .round))
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(gradient: progress > 0.5 ? gradient_b : gradient_a, center: .center, angle: .degrees(0)),
                    style: StrokeStyle(lineWidth: line, lineCap: progress > 0.5 ? .butt : .round)
                )
            
            if progress > 0.5 {
                
                Circle()
                    .trim(from: 0, to: 0.001)
                    .stroke(
                        colour, style: StrokeStyle(lineWidth: line, lineCap: .round))
                    .rotationEffect(Angle(degrees: Double(360 * progress)))
                
            }
            
        })
        .padding(10)
        .rotationEffect(Angle(degrees: -90.0))
        
    }
    
}

struct ProgressElement_Previews: PreviewProvider {
    static var previews: some View {
      
        ProgressCircleElement(progress: .constant(1.0), colour: Colour(hex: "#E62E6B"))
        
    }
}
