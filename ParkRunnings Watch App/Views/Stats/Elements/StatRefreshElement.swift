//
//  StatRefreshElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 14/10/2022.
//

import Foundation
import SwiftUI

struct StatRefreshElement: View {
    
    @EnvironmentObject var design: DesignController

    let symbol: String
    let header: String
    let symbol_colour: String?
    let symbol_opacity: CGFloat?
    let subtext: String?
    let animated: Bool?
    
    init(symbol: String, header: String, symbol_colour: String? = nil, symbol_opacity: CGFloat? = nil, subtext: String? = nil, animated: Bool? = nil) {
        self.symbol = symbol
        self.header = header
        self.symbol_colour = symbol_colour
        self.symbol_opacity = symbol_opacity
        self.subtext = subtext
        self.animated = animated
    }
    
    var body: some View {
        
        ButtonElement(colour: Colour(hex: "#252525"), radius: design.size(size: .card_medium_radius), content: {
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                StatTitleElement(symbol: symbol, header: header, symbol_colour: symbol_colour, symbol_opacity: symbol_opacity, animated: animated)
                
                if let subtext = subtext {
                    Text(subtext)
                        .font(Font.system(size: design.size(text: .stat_header) - 2, weight: .medium, design: .default))
                        .monospacedDigit()
                        .foregroundColor(Colour(hex: "#FFFFFF"))
                        .italic()
                        .opacity(0.7)
                }
                
            })
            .padding(.vertical, design.size(size: .stat_vertical_padding))
            .padding(.horizontal, design.size(size: .stat_horizontal_padding))
            
        })
        
    }
    
}

struct StatRefreshElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        StatRefreshElement(symbol: "rays", header: "Refreshing", symbol_opacity: nil, animated: true)
            .environmentObject(design)
        
        StatRefreshElement(symbol: "exclamationmark.octagon.fill", header: "Refresh Failed", symbol_colour: "#EC4A4A", symbol_opacity: 1.0, subtext: "Last refreshed:\n2022-03-10 01:23:22")
            .environmentObject(design)
        
    }
}
