//
//  GeneralElements.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI


struct ListOverscroll: View {
    
    var height: CGFloat = 30
    
    var body: some View {
        Colour(hex: "#000000")
            .frame(width: 10, height: height, alignment: .center)
            .listRowPlatterColor(.clear)
            .opacity(0.0)
    }
    
}

struct ListBottomBlur: View {
    
    var colour: Colour = Colour(hex: "#000000")
    
    var body: some View {
        
        LinearGradient(colors: [1.0, 0.9, 0.7, 0.2, 0.0].map({ colour.opacity($0) }), startPoint: .bottom, endPoint: .top)
        
    }
    
}


struct GeneralElements_Previews: PreviewProvider {
    static var previews: some View {
        VStack(content: {
            
            Colour(hex: "FFFFFF")
            
            ListBottomBlur()
                .padding(.top, -80)
            
        })
        
        
    }
}
