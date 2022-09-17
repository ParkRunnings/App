//
//  SetupDetailsElement.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI

struct SetupDetailsElement: View {
    
    var step: SetupCardType
    var header: String
    var details: String
    
    @Binding var complete: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            
            HStack(alignment: .center, content: {
                
                HeadingTextElement(text: "\(step.rawValue).")
                    .frame(width: 17, alignment: .leading)
                
                HeadingTextElement(text: header)
                    .padding(.leading, -1)
                
                Spacer()
                
                Image(systemName: !complete ? "circle.dotted" : "checkmark.circle.fill") 
                    .font(Font.system(
                        size: 16,
                        weight: .bold,
                        design: .default
                    ))
                    .foregroundColor(Colour(hex: "#FFFFFF"))
                    .frame(width: 20, height: 20, alignment: .center)
                
            })
            .opacity(!complete ? 1.0 : 0.6)
            
            if !complete {
                SubheadingTextElement(text: details)
            }
            
        })
        .listRowPlatterColor(.clear)
        .padding(.bottom, 4)
        
    }
    
}

struct SetupDetailsElement_Previews: PreviewProvider {

    static var previews: some View {
        SetupDetailsElement(step: SetupCardType.barcode, header: "Barcode", details: "Initial setup of barcode", complete: .constant(true))
        SetupDetailsElement(step: SetupCardType.location, header: "Barcode", details: "Initial setup of barcode", complete: .constant(false))
    }

}
