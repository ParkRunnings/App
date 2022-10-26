//
//  ResultRunElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 17/10/2022.
//

import SwiftUI

struct ResultRunElement: View {
    
    var position: TimelinePosition
    var date: String
    var event: String
    var time: String
    var pb: Bool
    
    init(position: TimelinePosition, date: Date, event: String, time: String, pb: Bool) {
        
        self.position = position
        self.date = date.strftime(format: "MMM dd")
        self.event = event
        self.time = time
        self.pb = pb
        
    }
    
    var body: some View {
        
        ResultTimelineElement(position: position, mark: {
            
            ZStack(alignment: .center, content: {
                
                Colour(hex: pb ? "#198A47": "#909090")
                    .frame(width: 14, height: 14)
                    .cornerRadius(7)
                    .shadow(color: Color(hex: "#000000").opacity(0.8), radius: 4, x: 2, y: 2)
                
                Colour(hex: pb ? "#031D0E": "#0E0E0E")
                    .frame(width: 8, height: 8)
                    .cornerRadius(4)
                    .shadow(color: Color(hex: "#000000").opacity(0.3), radius: 4, x: 2, y: 2)
                
            })
            .padding(.leading, (14 - 3) / -2)
            .padding(.top, 8)
             
        }, content: {
            
            VStack(alignment: .leading, spacing: 4, content: {
                
                HStack(alignment: .center, spacing: 10, content: {
                    
                    StatTextElement(text: time)
                    
                    if pb {
                        
                        ResultTimeElement(text: "PB")
                            .padding(.horizontal, 6)
                            .background(content: {
                                Colour(hex: "#149C4E")
                                    .cornerRadius(8)
                            })
                            
                    }
                    
                })
                
                SubheadingTextElement(text: "\(date)  ·  \(event)")
                
            })
            .padding(.bottom, 18)
            
        })
        
    }
    
}

struct ResultRunElement_Previews: PreviewProvider {

    static let design = DesignController()
    
    static var previews: some View {
        ResultRunElement(position: .start, date: Date.now, event: "Bushy Park Run", time: "23:44", pb: true)
            .environmentObject(design)
    }

}
