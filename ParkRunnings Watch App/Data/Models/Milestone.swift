//
//  Milestone.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation

struct Milestone {
    
    let number: Int
    let colour: Colour
    
    var text: String {
        get {
            if number < 1000 {
                return String(number)
            } else {
                return String(number / 1000) + "K"
            }
        }
    }
    
    private static let lookup: Dictionary<Int, String> = [
        50: "#AB2E3E",
        100: "#2F2F2F",
        250: "#0F6C44",
        500: "#2763A0",
        1000: "#C37009",
        5000: "#853582"
    ]
    
    static func current(runs: Int) -> Milestone? {
        
        guard let current = lookup.keys.filter({ $0 <= runs}).max() else { return nil }
            
        return Milestone(number: current, colour: Colour(hex: lookup[current]!))
         
    }
    
    static func next(runs: Int) -> Milestone? {
        
        guard let next = lookup.keys.filter({ $0 > runs}).min() else { return nil }
        
        return Milestone(number: next, colour: Colour(hex: lookup[next]!))
        
    }
    
}
