//
//  StatTitleElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 14/10/2022.
//

import Foundation
import SwiftUI

struct StatTitleElement: View {
    
    @EnvironmentObject var design: DesignController
    
    @State var rotating: Bool = false
    
    let symbol: String
    let header: String
    let detail: String
    let symbol_colour: Colour
    let symbol_opacity: CGFloat
    let text_opacity: CGFloat
    let animated: Bool
    
    init(symbol: String, header: String, detail: String = "", symbol_colour: String? = nil, symbol_opacity: CGFloat? = nil, text_opacity: CGFloat? = nil, animated: Bool? = nil) {
        self.symbol = symbol
        self.header = header
        self.detail = detail
        self.symbol_colour = Colour(hex: symbol_colour ?? "#FFFFFF")
        self.symbol_opacity = symbol_opacity ?? 0.7
        self.text_opacity = text_opacity ?? 0.7
        self.animated = animated ?? false
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 1, content: {
            
            Image(systemName: symbol)
                .font(Font.system(
                    size: design.size(text: .stat_icon),
                    weight: .bold,
                    design: .default
                ))
                .foregroundColor(symbol_colour)
                .frame(width: design.size(text: .card_icon), height: design.size(text: .card_icon))
                .opacity(symbol_opacity)
                .rotationEffect(Angle.degrees(rotating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: rotating
                )
            
            StatHeaderElement(text: header)
                .opacity(text_opacity)
            
            Spacer()
            
            StatHeaderElement(text: detail)
                .opacity(text_opacity)
            
        })
        .onAppear(perform: {
            if animated {
                rotating = true
            }
        })
        
    }
    
}

struct StatTitleElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        VStack(content: {
            
            StatTitleElement(symbol: "rays", header: "Refreshing", detail: "Apr 22", animated: true)
                .environmentObject(design)
            
            StatTitleElement(symbol: "rays", header: "Refreshing", detail: "Apr 22", animated: false)
                .environmentObject(design)
            
        })
        
        
        
    }
}
