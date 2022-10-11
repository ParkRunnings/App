//
//  Charts.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 11/10/2022.
//

import Foundation
import Charts

struct RecentDistribution {
    
    var marks: Array<RecentDistributionMark>
    
    var mean: Double
    var deviation: Double
    
    var scale_upper: Double
    var scale_lower: Double
    
    init(results: Array<Run>, months: Int) {
        
        let now = Date.now
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        
        let dates = Array(repeating: (1 ... 12).reversed(), count: Int(ceil(Double(months + month) / Double(12)))).flatMap({ $0 })[12 - month ..< 12 - month + months].enumerated().map({
            calendar.date(from: DateComponents(
                calendar: calendar,
                year: year - Int(($0.offset + (12 - month)) / 12),
                month: $0.element,
                day: 1,
                hour: 0
            ))!
        })
            
        var raw: Dictionary<Date, Array<Double>> = dates.reduce(into: [:], { $0[$1] = [] })
        
        for result in results {
            
            let date = calendar.date(from: DateComponents(
                year: calendar.component(.year, from: result.date),
                month: calendar.component(.month, from: result.date),
                day: 1
            ))!
            
            if raw[date] != nil {
                raw[date]!.append(Double(result.time) / 60.0)
            }

        }
        
        let values = raw.values.flatMap({ $0 })
        let mean = values.mean()
        let deviation = values.stddev()
        
        self.mean = mean
        self.deviation = deviation
        
        // Filter the values that will be displayed on the chart to 3 standard deviations
        let scope_values = values.filter({ abs(mean - $0) <= deviation * 3 })

        self.scale_upper = scope_values.max()! + min(deviation, 3)
        self.scale_lower = scope_values.min()! - min(deviation, 3)  // To-Do: This could cause issues on runners who have not run for a year
        
        self.marks = raw.sorted(by: { $0.key < $1.key }).enumerated().map({
            RecentDistributionMark(id: $0.offset + 1, date: $0.element.key, mean: mean, deviation: deviation, values: $0.element.value)
        })
        
    }
    
}

struct ChartValue: Identifiable {
    
    var id: UUID = UUID()
    var value: Double
    
}

struct RecentDistributionMark: Identifiable {
    
    var id: Int
    
    var date: Date
    var min: Double
    var max: Double
    var mean: Double
    var outliers: Array<ChartValue>
    var excluded: Int
    
    init(id: Int, date: Date, mean: Double, deviation: Double, values: Array<Double>) {
        
        let inliers = values.filter({ abs(mean - $0) <= deviation * 2 })
        let outliers = values.filter({ abs(mean - $0) > deviation * 2 && abs(mean - $0) <= deviation * 3 })
        let excluded = values.filter({ abs(mean - $0) > deviation * 3 })
        
        self.id = id
        self.date = date  //.strftime(format: "MMMMM")
        self.min = inliers.min() ?? 0
        self.max = inliers.max() ?? 0
        self.mean = values.mean()
        self.outliers = outliers.map({ ChartValue(value: $0) })
        self.excluded = excluded.count
        
    }
    
}
