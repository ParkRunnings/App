//
//  BarcodeCardElement.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI
import BarcodeKit

struct BarcodeCardElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let number: String
    let icon: String
    
    init(number: String) {
        
        self.number = number
        
        switch number {
            
            case "A5181034": // Atticus
            self.icon = "mustache.fill"
            
            default:
            self.icon = "person.crop.circle"
            
        }
        
    }
  
    var body: some View {
        
        let bc = BK_Barcode128(data: number, type: .code_b)
        
        VStack(spacing: 0.0, content: {
            
            Image(uiImage: UIImage(cgImage: bc.generate(scale: 2)))
                .renderingMode(.original)
                .resizable()
                .clipped()
                .aspectRatio(3/1, contentMode: .fit)
                .cornerRadius(4)
                .padding(.horizontal, design.size(size: .barcode_horizontal_padding))
                .padding(.top, design.size(size: .barcode_vertical_padding))
                
            HStack(content: {
                
                AthleteNumberTextElement(text: number, colour: "#A9AEBE")
                    
                Spacer()
                
                Image(systemName: icon)
                    .font(Font.system(
                        size: design.size(text: .card_icon),
                        weight: .bold,
                        design: .default
                    ))
                    .foregroundColor(Colour(hex: "#A9AEBE"))
                
            })
            .padding(design.size(size: .barcode_horizontal_padding))
            
        })
        .background(
            RoundedRectangle(cornerRadius: design.size(size: .barcode_card_radius))
                .fill(Color.white)
                .shadow(radius: 3)
        )
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct BarcodeCardElement_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeCardElement(number: "A5470914")
    }
}
