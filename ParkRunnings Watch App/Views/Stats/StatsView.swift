//
//  StatsView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 9/10/2022.
//

import Foundation
import SwiftUI

struct StatsView: View {
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var design: DesignController
    @EnvironmentObject var runner: RunnerController
    
    @State var scrape_status: ScrapeStatus = .scraping
    
    var body: some View {
        
        List(content: {
            
            TitleTextElement(text: "Statistics")
                .padding(.bottom, 12)
            
            if scrape_status == .scraping {
                StatRefreshElement(symbol: "rays", header: "Refreshing", symbol_opacity: nil, animated: true)
                    .padding(.bottom, 4)
            } else if scrape_status == .failed {
                StatRefreshElement(symbol: "exclamationmark.octagon.fill", header: "Refresh Failed", symbol_colour: "#EC4A4A", symbol_opacity: 1.0, subtext: "Last refreshed:\n\((runner.refreshed ?? Date.now).strftime(format: "HH:mm:SS YYYY-MM-dd"))")
                    .padding(.bottom, 4)
            }
            
            if let fastest = runner.fastest {
                StatValueElement(colour: "#28C563", symbol: design.watch.version >= 9.0 ? "trophy.fill" : "timer", header: "Fastest", detail: fastest.display_date, value: fastest.display_time)
                    .padding(.bottom, 4)
            }

            VStack(alignment: .leading, spacing: 10, content: {

                StatValueElement(colour: "#4622AD", symbol: design.watch.version >= 9.0 ? "figure.run" : "figure.walk", header: "Runs", detail: runner.latest?.display_date ?? "-", value: String(runner.runs))

                StatMilestoneElement(runs: runner.runs, current_milestone: runner.current_milestone, next_milestone: runner.next_milestone)

            })
                .padding(.bottom, 10)
                .listRowPlatterColor(.clear)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            if #available(watchOS 9.0, *), runner.results_sorted.count > 0 {

                StatMonthlyChart(results: runner.results_sorted, months: 9)
                    .padding(.bottom, 4)

            }

            if let streak = runner.streak {
                StatValueElement(colour: "#DD7F3B", symbol: "square.stack.3d.down.right.fill", header: "Best Streak", detail: streak.display_date, value: String(streak.streak))
                    .padding(.bottom, 4)
            }
            
            if let latest = runner.latest {
                StatValueElement(colour: "#2899B3", symbol: "square.stack.3d.down.right", header: "Current Streak", detail: "Now", value: String((Date.now - latest.date) / 86400 <= 7 ? latest.streak : 0))
                    .padding(.bottom, 4)
            }
            
            if #available(watchOS 9.0, *), runner.results_fastest.count > 0 {

                StatBurndownChart(results: runner.results_fastest)
                    .padding(.bottom, 4)
                    
            }
              
        })
        .listStyle(.carousel)
        .onAppear(perform: {
            
            Task(operation: {
                
                do {
                    
                    let runner_ = try await runner.scrape(number: runner.number)
                    
                    if let error = runner_.error {
                        throw RunnerControllerError.scrape(title: error)
                    }
                    
                    meta.update_runner(runner: runner_)
                    scrape_status = .completed

                } catch {
                    print("Scrape status failed")
                    scrape_status = .failed
                }

            })
            
        })
        
    }
    
}
