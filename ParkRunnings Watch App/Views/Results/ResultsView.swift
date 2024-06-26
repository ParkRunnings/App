//
//  ResultsView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 17/10/2022.
//

import Foundation
import SwiftUI

struct ResultsView: View {
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var design: DesignController
    @EnvironmentObject var runner: RunnerController
    
    @State var scrape_status: ScrapeStatus = .scraping
    @State var results: ResultBreakdown
    
    var body: some View {
            
        List(content: {
            
            ResultTitleView(scrape_status: $scrape_status, refreshed: $runner.refreshed)
            
            ForEach(results.data, content: { result in
                
                Section(content: {
                    
                    ForEach(result.data, content: { run in
                        
                        ResultRunElement(position: .middle, date: run.date, event: run.event, time: run.display_time, pb: run.pb)
                            .padding(.bottom, -11)
                        
                    })
                    
                    
                }, header: {
                    
                    ResultTimeElement(text: result.year, colour: "#F4D9D3")
                        .padding(.trailing, 10)
                        .padding(.leading, 10)
                        .padding(.top, 3)
                        .padding(.bottom, 4)
                        .background(content: {
                            Colour(hex: "#CE4F30")
                                .cornerRadius(10)
                                .shadow(color: Color(hex: "#000000").opacity(0.8), radius: 4, x: 2, y: 2)
                        })
                        .padding(.leading, -6)
                        .padding(.bottom, 10)
                        .padding(.top, result.first ? -30 : 20)
                    
                })
                
            })
            
            if results.data.count == 0 {
                
                ResultTimeElement(text: "NO RUNS YET", colour: "#D6D6D6")
                    .padding(.trailing, 10)
                    .padding(.leading, 10)
                    .padding(.top, 3)
                    .padding(.bottom, 4)
                    .background(content: {
                        Colour(hex: "#333333")
                            .cornerRadius(10)
                            .shadow(color: Color(hex: "#000000").opacity(0.8), radius: 4, x: 2, y: 2)
                    })
                    .padding(.leading, 2)
                    .padding(.bottom, 10)
                    .padding(.top, -30)
                
            }
            
        })
        .background(alignment: .leading, content: {
                        
//            Rectangle()
//                .frame(width: 3, height: design.watch.size.height - design.size(size: .result_timeline_top_padding))
//                .foregroundColor(Colour(hex: "#1A1A1A"))
//                .padding(.leading, 10)
//                .padding(.top, design.size(size: .result_timeline_top_padding))
        
        })
        .onAppear(perform: {
            
            Task(operation: {
                
                do {
                    
                    let (runner_, _) = try await runner.scrape(number: runner.number)
                    
                    if let error = runner_.error {
                        throw RunnerControllerError.scrape(title: error)
                    }
                    
                    meta.update_runner(runner: runner_)
                    scrape_status = .completed
                    
                    results = ResultBreakdown(results: runner.results_sorted)
                    
                } catch {
                    print("Scrape status failed")
                    scrape_status = .failed
                }
                
            })
            
        })
        
    }
    
}
