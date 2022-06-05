//
//  InputButtonElement.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI

struct InputButtonElement: View {
   
    let type: InputButtonType
    
    var body: some View {
    
        ButtonElement(colour: Colour(red: 0.16, green: 0.15, blue: 0.20), radius: 10, content: {
         
            switch type {
                
            case .confirm, .delete:
                Image(systemName: type == .confirm ? "checkmark.circle.fill" : "delete.left.fill")
                    .font(Font.system(size: 15, weight: .black))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(type == .confirm ? Color(red: 0.56, green: 0.87, blue: 0.44) : Color(red: 0.95, green: 0.43, blue: 0.43))
                
            default:
                Text("\(type.rawValue)")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .foregroundColor(Color(red: 1.00, green: 1.00, blue: 1.00))
                    .font(Font.system(size: 22, weight: .heavy, design: .rounded))
            }
        
        })
        .padding(.all, 3)
            
    }
    
}

struct InputButtonElement_Previews: PreviewProvider {
    static var previews: some View {
        InputButtonElement(type: .zero)
    }
}
