//
//  Array.swift
//  ParkRunnings WatchKit Extension
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
        
        return Double(Calendar.current.dateComponents([.second], from: rhs, to: lhs).second ?? 0)
        
    }
    
    func update_start(hour: Int, minute: Int) -> Self {
        
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self)!
        
    }
    
    func strftime(format: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
        
    }

}

extension String {
    
    func strip() -> Self {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    func namecased() -> Self {
        
        var names = self.lowercased().split(separator: " ").map({ String($0) })
        
        for index in names.indices {
            for separator in ["-", "'"] {
                names[index] = names[index].split(separator: Character(separator)).map({ $0.capitalized }).joined(separator: separator)
            }
        }
        
        return names.joined(separator: " ")
        
    }
    
}

extension UUID {
    
    func string() -> String {
        return self.description.lowercased()
    }
    
}

extension Int16 {
    
    func leading_zeros(width: Int) -> String {
        
        var number = String(self)
        
        if number.count < width {
            number = String(repeating: "0", count: width - number.count) + number
        }
        
        return number
        
    }
    
}

extension Array where Element == Double {
    
    func sum() -> Double {
        
        return self.reduce(0, +)
        
    }
    
    func mean() -> Double {
            
        Double(self.sum()) / Double(self.count)
        
    }
    
    func stddev() -> Double {
        
        let mean = self.mean()
        
        return sqrt(self.reduce(0, { $0 + pow((Double($1) - mean), 2) }) / Double(self.count))
        
    }
    
}
