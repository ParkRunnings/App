//
//  ResultTitleElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 20/10/2022.
//

import Foundation
import SwiftUI

struct ResultTitleView: View {
    
    @Binding var scrape_status: ScrapeStatus
    @Binding var refreshed: Date?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            ZStack(alignment: .topLeading, content: {
                
                Rectangle()
                    .foregroundColor(Colour(hex: "#000000"))
                    
                
                VStack(alignment: .leading, spacing: 0, content: {
                    
                    TitleElement(title: "Results", subtitle: nil)
                        .padding(.bottom, -10)
                    
                    if scrape_status == .scraping {
                        StatRefreshElement(symbol: "rays", header: "Refreshing", symbol_opacity: nil, animated: true)
                            .padding(.bottom, 10)
                    } else if scrape_status == .failed {
                        StatRefreshElement(symbol: "exclamationmark.octagon.fill", header: "Refresh Failed", symbol_colour: "#EC4A4A", symbol_opacity: 1.0, subtext: "Last refreshed:\n\((refreshed ?? Date.now).strftime(format: "HH:mm:SS YYYY-MM-dd"))")
                            .padding(.bottom, 10)
                    }
                        
                })
                .padding(.top, 100)
                
            })
            .padding(.top, -100)
            
            Rectangle()
                .frame(width: 3, height: 6)
                .cornerRadius(0.1)
                .foregroundColor(Colour(hex: "#000000"))
                .mask(HoleShapeMask(in: CGRect(x: 0, y: 0, width: 3, height: 12)).fill(style: FillStyle(eoFill: true)))
                .padding(.leading, 10)
                .listRowPlatterColor(.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            
        })
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .padding(.bottom, 20)
        
    }
    
}

func HoleShapeMask(in rect: CGRect) -> Path {
    var shape = Rectangle().path(in: rect)
    shape.addPath(Circle().path(in: rect))
    return shape
}

struct ResultTitleView_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        ResultTitleView(scrape_status: .constant(.scraping), refreshed: .constant(nil))
            .environmentObject(design)
    }
}

