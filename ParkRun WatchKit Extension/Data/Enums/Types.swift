//
//  Enums.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation

enum InputButtonType: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine, delete, confirm
}

enum SetupCardType: Int, CaseIterable {
    
    case barcode = 1, location, event
    
    static func all() -> Array<SetupCardType> {
        return SetupCardType.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    }
    
}

enum LocationRadius: Double, CaseIterable {

    case km_3 = 3000
    case km_5 = 5000
    case km_10 = 10000
    case km_30 = 20000
    case km_50 = 50000
    
    static func ascending() -> Array<LocationRadius> {
        return LocationRadius.allCases.sorted(by: {$0.rawValue < $1.rawValue})
    }
    
}

//extension EventCountry: CustomStringConvertible {
//    var description: String {
//        return "City \()"
//    }
//}
