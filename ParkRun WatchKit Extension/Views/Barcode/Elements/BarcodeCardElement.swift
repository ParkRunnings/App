//
//  BarcodeCardElement.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI
import BarcodeKit

struct BarcodeCardElement: View {
    
    let number: String
  
    var body: some View {
        
        let bc = BK_Barcode128(data: number, type: .code_b)
        
        VStack(spacing: 0.0, content: {
            
            Image(uiImage: UIImage(cgImage: bc.generate(scale: 2)))
                .renderingMode(.original)
                .resizable()
                .clipped()
                .cornerRadius(4)
                .aspectRatio(2/1, contentMode: .fit)
                .padding(.horizontal, 14.0)
                .padding(.top, 20.0)
            
            HStack(content: {
                
                Text(number)
                    .font(Font.system(
                        size: 17,
                        weight: .bold,
                        design: .monospaced
                    ))
                    .italic()
                    
                Spacer()
                
                Image(systemName: "person.crop.circle")
                    .font(Font.system(
                        size: 18,
                        weight: .bold,
                        design: .default
                    ))
                
            })
            .padding(14.0)
            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.1))
            
        })
        
        
        .background(
            RoundedRectangle(cornerRadius: 24)
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
