//
//  StatValueElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI

struct StatValueElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let colour: String
    let symbol: String
    let header: String
    let detail: String
    let value: String
    
    var body: some View {
        
        ButtonElement(colour: Colour(hex: colour), radius: design.size(size: .card_medium_radius), content: {
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                StatTitleElement(symbol: symbol, header: header, detail: detail)
                
                StatTextElement(text: value)
                
            })
            .frame(height: design.size(size: .card_medium_height), alignment: .center)
            .padding(.vertical, design.size(size: .stat_vertical_padding))
            .padding(.horizontal, design.size(size: .stat_horizontal_padding))
            
        })
        
    }
    
}

struct StatValueElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        StatValueElement(colour: "#45BB70", symbol: "figure.walk", header: "Runs", detail: "Apr 22", value: "153")
            .environmentObject(design)
        
    }
}
