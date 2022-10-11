//
//  GraphElement.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI
import Charts

struct MonthlyDistributionElement: View {
    
    let colour: String
    let symbol: String
    let header: String
    let date: String
    
    @State var data: RecentDistribution
    @EnvironmentObject var design: DesignController
    
    var body: some View {

        ButtonElement(colour: Colour(hex: colour), radius: design.size(size: .card_medium_radius), content: {
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                HStack(alignment: .center, spacing: 1, content: {
                    
                    Image(systemName: symbol)
                        .font(Font.system(
                            size: 9, //design.size(text: .card_icon),  // To-Do: Add as design size
                            weight: .bold,
                            design: .default
                        ))
                        .foregroundColor(Colour(hex: "#FFFFFF"))
                        .frame(width: design.size(text: .card_icon), height: design.size(text: .card_icon))

                    StatHeaderElement(text: header)
                        
                    Spacer()

                    StatHeaderElement(text: date)
                    
                })
                .opacity(0.7)
                .padding(.bottom, -4)
                
                Chart(data.marks, content: { mark in
                    
                    RuleMark(x: .value("Month", mark.id), yStart: .value("Start Time", data.scale_lower), yEnd: .value("End Time", data.scale_upper))
                        .lineStyle(StrokeStyle(lineWidth: 0.8))
                        .foregroundStyle(Colour(hex: "#686972"))
                        .opacity(0.5)

                    BarMark(
                        x: .value("Month", mark.id),
                        yStart: .value("Start Time", mark.min),
                        yEnd: .value("End Time", mark.max)
                    )
                    .cornerRadius(2)
                    .foregroundStyle(Color(hex: "#681631"))

                    RuleMark(xStart: .value("Month", Double(mark.id) - 0.4), xEnd: .value("Month", Double(mark.id) + 0.4), y: .value("Median", mark.mean))
                        .cornerRadius(2)
                        .foregroundStyle(Colour(hex: "#ED0B57"))

                    ForEach(mark.outliers, content: { outlier in
                        PointMark(x: .value("Month", mark.id), y: .value("Time", outlier.value))
                            .opacity(0.3)
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
                .chartYScale(domain: ClosedRange(uncheckedBounds: (data.scale_lower, data.scale_upper)))
                .chartXScale(domain: ClosedRange(uncheckedBounds: (0, data.marks.count + 1)))
                
                HStack(alignment: .center, spacing: 10, content: {
                    
                    HStack(alignment: .center, spacing: 3, content: {
                        
                        Colour(hex: "#ED0B57")
                            .frame(width: 6, height: 6)
                            .cornerRadius(3)
                        
                        Text("Average")
                            .font(Font.system(size: 6, weight: .medium, design: .default))
                        
                    })
                    
                    HStack(alignment: .center, spacing: 3, content: {
                        
                        Colour(hex: "#681631")
                            .frame(width: 6, height: 6)
                            .cornerRadius(3)
                        
                        Text("Range")
                            .font(Font.system(size: 6, weight: .medium, design: .default))
                        
                    })
                    
                })
                .padding(.top, -4)
                
            })
            .frame(height: 130, alignment: .center)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            
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
