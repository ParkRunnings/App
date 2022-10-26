//
//  ResultTimelineElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 19/10/2022.
//

import SwiftUI

struct ResultTimelineElement<A: View, B: View>: View where A: View {

    var position: TimelinePosition
    
    var mark: () -> A
    var content: () -> B
    
    init(position: TimelinePosition, @ViewBuilder mark: @escaping () -> A, @ViewBuilder content: @escaping () -> B = { EmptyView() }) {
        
        self.position = position
        self.mark = mark
        self.content = content
        
    }

    var body: some View {
      
        ZStack(alignment: position.alignment(), content: {
            
            HStack(alignment: .top, spacing: 14, content: {
                
                mark()
                    
                ButtonElement(colour: Colour(hex: "#000000"), radius: 0, content: {
                    content()
                })
                
                
            })
            
        })
        .padding(.leading, 10)
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
}

struct ResultTimelineElement_Previews: PreviewProvider {

    static let design = DesignController()
    
    static var previews: some View {
        ResultTimelineElement(position: .middle, mark: {
            Colour(hex: "#F26B51")
                .frame(width: 10, height: 10)
                .cornerRadius(5)
                .padding(.leading, -3)
                .padding(.top, 5)
        }, content: {
            
            VStack(alignment: .leading, spacing: 20, content: {
                Text("Fuck")
                Text("You")
                Text("You")
            })
            
            
        })
            .environmentObject(design)
    }

}
