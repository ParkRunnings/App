//
//  Colour.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import SwiftUI
import UIKit

typealias Colour = Color

extension Color {
    
    init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
        
    }
    
    func darken(percentage: Double) -> Colour {
        
        let multiplier = 1.0 - percentage
        
        guard var components = UIColor(self).cgColor.components, components.count >= 3 else {
            fatalError()
        }
        
        if components.count == 3 {
            components.append(1.0)
        }
        
        return Colour(
            red: Double(components[0]) * multiplier,
            green: Double(components[1]) * multiplier,
            blue: Double(components[2]) * multiplier,
            opacity: Double(components[3])
        )
        
    }
    
}
