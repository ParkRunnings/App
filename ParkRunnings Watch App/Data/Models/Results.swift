//
//  Results.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 18/10/2022.
//

import Foundation

struct ResultAnnualResults: Identifiable {
    
    var id: UUID = UUID()
    var year: String
    var first: Bool
    var data: Array<Run>
    
}

struct ResultBreakdown {
    
    var data: Array<ResultAnnualResults>
    
    init(results: Array<Run>) {

        var holding: Dictionary<Int, Array<Run>> = [:]
        
        for run in results {
            holding[Int(run.date.strftime(format: "YYYY"))!, default: []].append(run)
        }

        data = holding.sorted(by: { $0.key > $1.key }).enumerated().map({ ResultAnnualResults(year: String($1.key), first: $0 == 0, data: $1.value.sorted(by: { $0.date > $1.date })) })
        
    }
    
}
