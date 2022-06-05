//
//  MainCardElement.swift
//  ParkRun
//
//  Created by Charlie on 4/4/2022.
//

import SwiftUI

//struct MainCardElement: View {
//    
//    let type: MainCardType
//    
//    private let title: String
//    private let symbol: String
//    private let colour: Colour
//    
//    init(type: MainCardType) {
//        
//        self.type = type
//        
//        switch type {
//            
//        case .setup:
//            self.title = "Setup Barcode"
//            self.symbol = "barcode"
//            self.colour = Colour(hex: "D1852B")
//            
//        case .barcode:
//            self.title = "View Barcode"
//            self.symbol = "barcode.viewfinder"
//            self.colour = Colour(hex: "4B64A7")
//            
//        }
//        
//        
//    }
//    
//    var body: some View {
//        
//        HStack(content: {
//            
//            Text(title)
//                .font(Font.system(
//                    size: 19,
//                    weight: .bold,
//                    design: .default
//                ))
//                .italic()
//                
//            Spacer()
//            
//            Image(systemName: symbol)
//                .font(Font.system(
//                    size: 24,
//                    weight: .bold,
//                    design: .default
//                ))
//            
//        })
//        .padding(14.0)
//        .padding(.top, 50.0)
//        .background(
//            RoundedRectangle(cornerRadius: 24)
//                .fill(colour)
//                .shadow(radius: 3)
//        )
//        
//    }
//    
//}
//
//struct MainCardElement_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        MainCardElement(type: .barcode)
//    }
//    
//}
