//
//  Array.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

extension Double {

    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

}

extension Date {
    
    static func - (lhs: Self, rhs: Self) -> TimeInterval {
        
        return Double(Calendar.current.dateComponents([.second], from: lhs, to: rhs).second ?? 0)
        
    }

}
