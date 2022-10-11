//
//  StatsView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI

struct StatsView: View {
    
    @EnvironmentObject var runner: RunnerController
    
    var body: some View {
        
        List(content: {
            
            TitleTextElement(text: "Statistics")
                .padding(.bottom, 12)
            
            if let fastest = runner.fastest {
                StatTitleElement(colour: "#45BB70", symbol: "trophy.fill", header: "Fastest", date: fastest.display_date, value: fastest.display_time)
                    .padding(.bottom, 4)
            }
            
            if let latest = runner.latest {
                
                VStack(alignment: .leading, spacing: 10, content: {
                    
                    StatTitleElement(colour: "#7145BA", symbol: "figure.run", header: "Runs", date: latest.display_date, value: String(latest.number))
                    
                    MilestoneCounterElement(runs: runner.runs, current_milestone: runner.current_milestone, next_milestone: runner.next_milestone)
                    
                })
                    .padding(.bottom, 10)
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            MonthlyDistributionElement(colour: "#20222D", symbol: "calendar", header: "Past Year", date: "21-22", data: RecentDistribution(results: runner.results_sorted, months: 12))
                .padding(.bottom, 4)
            
            StatTitleElement(colour: "#E6A749", symbol: "checklist", header: "Run Streak", date: "Jan 22", value: "22")
                .padding(.bottom, 4)
            
//            GraphElement()
//                .listRowPlatterColor(.clear)
//                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//            
        })
        .listStyle(.carousel)
        
    }
    
}
