//
//  StatBurndownChart.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 17/10/2022.
//

import Foundation
import SwiftUI
import Charts

@available(watchOS 9.0, *)
struct StatBurndownChart: View {
    
    @EnvironmentObject var design: DesignController
    
    @State var data: StatBurndown
    
    init(results: Array<Run>) {
        self.data = StatBurndown(results: results)
    }
    
    var body: some View {
        
        ButtonElement(colour: Colour(hex: "#1E202B"), radius: design.size(size: .card_medium_radius), content: {
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                StatTitleElement(symbol: "chart.line.downtrend.xyaxis", header: "PB Burndown", detail: "")
                .padding(.bottom, -4)

                Chart(data.marks, content: { run in

                    LineMark(x: .value("Run", run.x), y: .value("Time", run.y))
                        .foregroundStyle(Colour(hex: "#2194FA"))
                    
                })
                .chartXScale(domain: data.scale_x)
                .chartYScale(domain: data.scale_y)
                
                HStack(alignment: .center, spacing: 10, content: {

                    StatLegendElement(colour: "#2194FA", text: "Fastest Time")

                })
                .padding(.top, -2)
                
            })
            .frame(height: design.size(size: .card_graph_height), alignment: .center)
            .padding(.vertical, design.size(size: .stat_vertical_padding))
            .padding(.horizontal, design.size(size: .stat_horizontal_padding))
            
        })
        
    }
    
}

//struct GraphElement_Previews: PreviewProvider {
//
//    static let context = DataController.shared.container.viewContext
//    static let calendar = Calendar.current
//
//    static var previews: some View {
//
//        MonthlyDistributionElement(data: RecentDistribution(results: [
//            Run(context: context, date: calendar.date(from: DateComponents(year: 2022, month: 10, day: 2))!, event: "Cooks River", position: 3, time: 1200),
//            Run(context: context, date: calendar.date(from: DateComponents(year: 2022, month: 10, day: 8))!, event: "Cooks River", position: 3, time: 1020),
//            Run(context: context, date: calendar.date(from: DateComponents(year: 2022, month: 10, day: 6))!, event: "Cooks River", position: 3, time: 1340),
//            Run(context: context, date: calendar.date(from: DateComponents(year: 2022, month: 9, day: 1))!, event: "Cooks River", position: 3, time: 1240),
//            Run(context: context, date: calendar.date(from: DateComponents(year: 2022, month: 9, day: 2))!, event: "Cooks River", position: 3, time: 1800)
//        ], months: 12))
//
//    }
//}
