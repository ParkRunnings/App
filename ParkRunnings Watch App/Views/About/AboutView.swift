//
//  AboutView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/4/2023.
//

import Foundation
import SwiftUI

struct AboutView: View {
    
    var body: some View {
        
        List(content: {
            
            TitleElement(
                title: "About",
                subtitle: [
                    "",
                    "👨🏽‍💻  Charles Schacher",
                    "📍  Sydney, Australia",
                    "📮  hello@schacher.dev"
                ].joined(separator: "\n")
            )
                .padding(.bottom, 10)
            
        })
        
    }
    
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
