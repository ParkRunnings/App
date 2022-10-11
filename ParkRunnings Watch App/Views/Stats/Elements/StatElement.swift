//
//  StatElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI

struct StatTitleElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let colour: String
    let symbol: String
    let header: String
    let date: String
    let value: String
    
    var body: some View {
        
        ButtonElement(colour: Colour(hex: colour), radius: design.size(size: .card_medium_radius), content: {
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                HStack(alignment: .center, spacing: 1, content: {
                    
                    Image(systemName: symbol)
                        .font(Font.system(
                            size: 9, //design.size(text: .card_icon),  // To-Do: Add as design size
                            weight: .bold,
                            design: .default
                        ))
                        .foregroundColor(Colour(hex: "#FFFFFF"))
                        .frame(width: design.size(text: .card_icon), height: design.size(text: .card_icon))
                    
                    StatHeaderElement(text: header)
                    
                    Spacer()
                    
                    StatHeaderElement(text: date)
                    
                })
                .opacity(0.7)
                
                StatTextElement(text: value)
                
            })
            .frame(height: design.size(size: .card_medium_height), alignment: .center)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            
        })
        
    }
    
}

struct StatElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        StatTitleElement(colour: "#45BB70", symbol: "figure.run", header: "Runs", date: "Apr 22", value: "153")
            .environmentObject(design)
        
    }
}
