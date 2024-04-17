//
//  RunnerController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 8/5/2022.
//

import SwiftUI
import CoreData
import SwiftSoup

class RunnerController: NSObject, ObservableObject {
    
    static let shared = RunnerController()
    
    var current: Runner?
    
    @Published var name: String!
    @Published var number: String!
    @Published var a_number: String!
    
    @Published var results_sorted: Array<Run>!
    @Published var results_fastest: Array<Run>!
    
    @Published var fastest: Run?
    @Published var latest: Run?
    @Published var streak: Run?
    @Published var runs: Int!
    @Published var refreshed: Date?
    
    @Published var current_milestone: Milestone?
    @Published var next_milestone: Milestone?
    
    override init() {
        
        super.init()
      
        self.update()
        
    }
    
    func fetch(context: NSManagedObjectContext? = nil, number: String? = nil) -> Runner? {
        
        let context = context ?? DataController.shared.container.viewContext
        
        guard let number = number ?? MetaController.shared.runner_number else { return nil }
        
        print("Fetch: \(number)")
        
        let request = Runner.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        
        guard let runner = try! context.fetch(request).first else {
            return nil
        }
        
        return runner
        
    }
    
    func fetch(number: String? = nil, sort: Array<NSSortDescriptor> = []) -> Array<Run> {
        
        let context = DataController.shared.container.viewContext
        
        guard let number = number ?? MetaController.shared.runner_number else { return [] }
        
        let request = Run.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number as String])
        request.sortDescriptors = sort
        
        guard let results = try? context.fetch(request) else { return [] }
        
        return results
        
    }
    
    func update() {
        
        current = self.fetch()
        
        name = current?.name ?? "-"
        number = current?.number ?? MetaController.shared.runner_number ?? "?"
        a_number = current?.a_number ?? "A490"
        
        // To-Do: Add a runner refresh op to the timer task
        
        results_sorted = fetch(sort: [NSSortDescriptor(key: "date", ascending: true)])
        results_fastest = fetch(sort: [NSSortDescriptor(key: "time", ascending: true), NSSortDescriptor(key: "date", ascending: true)])
        
        fastest = results_fastest.first
        latest = results_sorted.last
        streak = results_sorted.sorted(by: { ($0.streak, $0.date) > ($1.streak, $1.date) }).first
        
        runs = results_sorted.count
        refreshed = current?.refreshed
        
        current_milestone = Milestone.current(runs: runs)
        next_milestone = Milestone.next(runs: runs)
        
    }
    
    func scrape_runner_all_html(number: String) async throws -> String {
        
        return try await scrape_catch(request: {
            return await String(
                decoding: try DataController.shared.request(
                    url: URL(string: "https://www.parkrun.com.au/parkrunner/\(number)/all/")!,
                    header: ["User-Agent": DataController.shared.user_agent]
                ),
                as: UTF8.self
            )
        })
        
    }
    
    func scrape_runner_summary_html(number: String) async throws -> String {
        
        return try await scrape_catch(request: {
            return await String(
                decoding: try DataController.shared.request(
                    url: URL(string: "https://www.parkrun.com.au/parkrunner/\(number)/")!,
                    header: ["User-Agent": DataController.shared.user_agent]
                ),
                as: UTF8.self
            )
        })
        
    }
    
    func convert_html(context: NSManagedObjectContext, number: String, runner_all_html: String, runner_summary_html: String) throws -> (Runner, Array<Run>) {
        
        let runner = try Runner(context: context, number: number, all_events_html: runner_all_html)
        let runs = try Run.from_scrape(context: context, number: number, all_events_html: runner_all_html, summary_events_html: runner_summary_html)
        
        return (runner, runs)
        
    }
    
    func scrape(number: String) async throws -> (Runner, Array<Run>) {

        async let runner_all_html = scrape_runner_all_html(number: number)
        async let runner_summary_html = scrape_runner_summary_html(number: number)

        let context = DataController.shared.container.viewContext

        let runner_all_html_await = try await runner_all_html
        let runner_summary_html_await = try await runner_summary_html
        
        return try await context.perform({
            return (
                try Runner(context: context, number: number, all_events_html: runner_all_html_await),
                try Run.from_scrape(context: context, number: number, all_events_html: runner_all_html_await, summary_events_html: runner_summary_html_await)
            )
        })
        
    }

    private func scrape_catch<T>(request: () async throws -> T) async throws -> T {
        
        do {
            return try await request()
        } catch let error as URLError {

            switch error.code {

                case .notConnectedToInternet:
                throw RunnerControllerError.scrape(title: "Internet offline")

                default:
                throw RunnerControllerError.scrape(title: "Unknown Network Error")

            }

        } catch {
            throw RunnerControllerError.scrape(title: "Unknown Error")
        }
      
    }

}
