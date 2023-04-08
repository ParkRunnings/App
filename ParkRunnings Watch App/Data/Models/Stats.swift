//
//  Stats.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 11/10/2022.
//

import Foundation
import Charts

struct StatSingleValue: Identifiable {
    
    var id: UUID = UUID()
    var y: Double
    
}

struct StatDoubleValue: Identifiable {
    
    var id: UUID = UUID()
    var x: Int
    var y: Double
    
}

struct StatMonthly {

    var marks: Array<StatMonthlyMark>

    var mean: Double
    var deviation: Double

    var scale_x: ClosedRange<Int>
    var scale_y: ClosedRange<Double>

    init(results: Array<Run>, months: Int) {

        let now = Date.now
        let calendar = Calendar.current
        
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

        if scope_values.count > 0 {
            self.scale_x = 0 ... raw.count + 1
            self.scale_y = floor(scope_values.min()! - min(deviation, 3)) ... ceil(scope_values.max()! + min(deviation, 3)) // To-Do: This could cause issues on runners who have not run for a year
        } else {
            self.scale_x = 0 ... raw.count + 1
            self.scale_y = 0.0 ... 60.0
        }
        
        self.marks = raw.sorted(by: { $0.key < $1.key }).enumerated().map({
            StatMonthlyMark(id: $0.offset + 1, date: $0.element.key, mean: mean, deviation: deviation, values: $0.element.value)
        })
        
        print(scale_x, scale_y)

    }

}

struct StatMonthlyMark: Identifiable {

    var id: Int

    var date: Date
    var min: Double?
    var max: Double?
    var mean: Double?
    var outliers: Array<StatSingleValue>
    var excluded: Int

    init(id: Int, date: Date, mean: Double, deviation: Double, values: Array<Double>) {

        let inliers = values.filter({ abs(mean - $0) <= deviation * 2 })
        let outliers = values.filter({ abs(mean - $0) > deviation * 2 && abs(mean - $0) <= deviation * 3 })
        let excluded = values.filter({ abs(mean - $0) > deviation * 3 })

        let monthly_mean = values.mean()
        
        self.id = id
        self.date = date
        self.min = inliers.min()
        self.max = inliers.max()
        self.mean = monthly_mean.isNaN ? nil : monthly_mean
        self.outliers = outliers.map({ StatSingleValue(y: $0) })
        self.excluded = excluded.count
        
    }

}

struct StatBurndown {
    
    var marks: Array<StatDoubleValue>
    
    var scale_x: ClosedRange<Int>
    var scale_y: ClosedRange<Double>
    
    init(results: Array<Run>) {
        
        marks = results.filter({ $0.pb }).sorted(by: { $0.date < $1.date }).enumerated().map({ StatDoubleValue(x: $0.offset + 1, y: Double($0.element.time) / 60.0) })
        
        scale_x = 0 ... marks.count + 1
        
        if let first = marks.first, let last = marks.last {
            scale_y = last.y - 2 ... first.y + 2
        } else {
            scale_y = 0 ... 30
        }
        
    }
    
}

