//
//  StatMilestoneElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI

struct StatMilestoneElement: View {
    
    let runs: Int
    let current_milestone: Milestone?
    let next_milestone: Milestone?
    
    var progress: Float {
        
        get {
            return Float(runs - (current_milestone?.number ?? 0)) / Float((next_milestone?.number ?? 0) - (current_milestone?.number ?? 0))
        }
        
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 12, content: {
        
            VStack(alignment: .leading, spacing: 4, content: {
            
                GeometryReader(content: { geometry in
                
                    ZStack(alignment: .leading, content: {
                    
                        Colour(hex: "#FFFFFF")
                            .cornerRadius(4)
                            .frame(height: 10)
                            .opacity(0.2)
                    
                        Colour(hex: "#32197C")
                            .cornerRadius(4)
                            .frame(width: max(geometry.size.width * CGFloat(progress), 10), height: 10)
                            
                        
                    })
                    
                })
                    .frame(height: 10)
                
                StatHeaderElement(text: "\(Int(progress * 100))% Progress")
                    .opacity(0.6)
                
            })
            
            VStack(alignment: .center, spacing: -2, content: {
                
                Text(next_milestone?.text ?? "?")
                    .font(Font.system(size: 13, weight: .bold, design: .rounded))
                    .padding(.top, -3)
                
                Text("CLUB")
                    .font(Font.system(size: 7, weight: .bold, design: .rounded))
                
            })
            .frame(width: 34, height: 34, alignment: .center)
            .background(content: {
                RoundedRectangle(cornerRadius: 17)
                    .fill(next_milestone?.colour ?? Colour(hex: "#FFFFFF"))
            })
            .padding(.top, -3)
            
        })
        .padding(.horizontal, 10)
        
    }
    
}

struct StatMilestoneElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        StatMilestoneElement(runs: 0, current_milestone: Milestone.current(runs: 0), next_milestone: Milestone.next(runs: 0))
            .environmentObject(design)
        
        StatMilestoneElement(runs: 2500, current_milestone: Milestone.current(runs: 2500), next_milestone: Milestone.next(runs: 2500))
            .environmentObject(design)
        
    }
}
