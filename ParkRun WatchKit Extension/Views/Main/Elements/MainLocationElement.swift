//
//  MainLocationElement.swift
//  ParkRun
//
//  Created by Charlie on 3/4/2022.
//

import SwiftUI
import CoreLocation

struct MainLocationElement: View {
    
    func gradient(percent: Double) -> Color {
        
        // A sloped function to alter the velocity of change in the gradient
        let y = -log(-percent + 1)
        
        let near: Dictionary<String, Double> = ["red": 0.38, "green": 0.86, "blue": 0.40]
        let far: Dictionary<String, Double> = ["red": 0.64, "green": 0.65, "blue": 0.64]
        
        return Color(
            red: near["red"]! + y * (far["red"]! - near["red"]!),
            green: near["green"]! + y * (far["green"]! - near["green"]!),
            blue: near["blue"]! + y * (far["blue"]! - near["blue"]!)
        )
        
    }
    
    var body: some View {
    
        HStack() {
            
            Image(systemName: "arrow.up.circle")
                .font(Font.system(.body).bold())
                .rotationEffect(Angle(degrees: 30.0))
            
            
            Text("12.4 KM")
                .font(Font.system(
                    size: 16,
                    weight: .bold,
                    design: .default
                ))
                .italic()
            
        }
        .padding(10.0)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(self.gradient(percent: 0.2))
                .shadow(radius: 3)
        )
        
    }
}

struct MainLocationElement_Previews: PreviewProvider {
     
    static var previews: some View {
        MainLocationElement()
    }
    
}
