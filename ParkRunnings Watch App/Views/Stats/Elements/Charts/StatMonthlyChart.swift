//
//  StatMonthlyChart.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI
import Charts

@available(watchOS 9.0, *)
struct StatMonthlyChart: View {

    @EnvironmentObject var design: DesignController

    @State var data: StatMonthly

    init(results: Array<Run>, months: Int) {
        self.data = StatMonthly(results: results, months: months)
    }

    var body: some View {

        ButtonElement(colour: Colour(hex: "#1E202B"), radius: design.size(size: .card_medium_radius), content: {

            VStack(alignment: .leading, spacing: 8, content: {

                StatTitleElement(symbol: "calendar", header: "Recent Times", detail: "")
                .padding(.bottom, -4)

                Chart(data.marks, content: { mark in

                    RuleMark(x: .value("Month", mark.id), yStart: .value("Start Time", data.scale_y.lowerBound), yEnd: .value("End Time", data.scale_y.upperBound))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Colour(hex: "#5C5D69"))

                    if let min = mark.min, let max = mark.max {
                        
                        BarMark(
                            x: .value("Month", mark.id),
                            yStart: .value("Start Time", min),
                            yEnd: .value("End Time", max)
                        )
                        .cornerRadius(2)
                        .foregroundStyle(Color(hex: "#681631"))
                        
                    }

                    if let mean = mark.mean {
                        RuleMark(xStart: .value("Month", Double(mark.id) - 0.4), xEnd: .value("Month", Double(mark.id) + 0.4), y: .value("Median", mean))
                            .cornerRadius(2)
                            .foregroundStyle(Colour(hex: "#ED0B57"))
                    }

                    ForEach(mark.outliers, content: { outlier in
                        PointMark(x: .value("Month", mark.id), y: .value("Time", outlier.y))
                            .foregroundStyle(Color(hex: "#681631"))
                    })

                })
                .chartXAxis(content: {
//                    AxisMarks(format: .dateTime.month(.narrow), preset: .aligned, position: .bottom, values: data.marks.map({ $0.date }), stroke: StrokeStyle(lineWidth: 1.0))
                    AxisMarks(preset: .aligned, position: .bottom, values: Array(1 ... data.marks.count), content: { mark in
                        AxisValueLabel(data.marks[mark.index].date.strftime(format: "MMMMM"))
                            .font(Font.system(size: 6, weight: .regular))
                    })

                    AxisMarks(preset: .aligned, position: .top, values: data.marks.filter({ $0.excluded > 0 }).map({ $0.id }), content: { mark in
                        AxisValueLabel("\(data.marks[mark.as(Int.self)! - 1].excluded)+")
                            .font(Font.system(size: 4, weight: .bold, design: .monospaced))
                    })

                })
                .chartXScale(domain: data.scale_x)
                .chartYScale(domain: data.scale_y)
                
                HStack(alignment: .center, spacing: 10, content: {

                    StatLegendElement(colour: "#ED0B57", text: "Average")

                    StatLegendElement(colour: "#681631", text: "Range")

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
