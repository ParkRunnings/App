//
//  PermissionView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 2/11/2022.
//

import Foundation
import SwiftUI

struct PermissionView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            
            List(content: {
                
                TitleElement(
                    title: "Location",
                    subtitle: [
                        "ParkRunnings needs location access to calculate distances to nearby events.",
                        "",
                        "To grant access, on your iPhone head to:",
                        "> `Privacy & Security`",
                        "> `Location Services`",
                        "> `ParkRunnings`",
                        "",
                        "Then enable 'While Using' location access."
                    ].joined(separator: "\n")
                )
                .padding(.bottom, 10)
                
            })
            
        })
        
    }
    
}

struct PermissionView_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        PermissionView()
            .environmentObject(design)
    }
}
