//
//  StatLegendElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 17/10/2022.
//

import Foundation
import SwiftUI
import Charts

struct StatLegendElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let colour: String
    let text: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 4, content: {
            
            Colour(hex: colour)
                .frame(width: design.size(size: .stat_legend_circle), height: design.size(size: .stat_legend_circle))
                .cornerRadius(Double(design.size(size: .stat_legend_circle)) / 2.0)
            
            Text(text)
                .font(Font.system(size: design.size(text: .stat_legend), weight: .medium, design: .monospaced))
                .foregroundColor(Colour(hex: "#BDBDC0"))
            
        })
        
    }
    
}
