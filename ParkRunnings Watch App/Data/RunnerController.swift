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
    
    func fetch() -> Runner? {
        
        let context = DataController.shared.container.viewContext
        
        guard let number = MetaController.shared.runner_number else { return nil }
        
        print("Fetch: \(number)")
        
        let request = Runner.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        
        guard let runner = try! context.fetch(request).first else {
            MetaController.shared.runner_number = nil
            DataController.shared.save()
            return nil
        }
        
        return runner
        
    }
    
    func fetch(sort: Array<NSSortDescriptor> = []) -> Array<Run> {
        
        let context = DataController.shared.container.viewContext
        
        let request = Run.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number as String])
        request.sortDescriptors = sort
        
        guard let results = try? context.fetch(request) else { return [] }
        
        return results
        
    }
    
    func update() {
        
        current = self.fetch()
        
        name = current?.name ?? "-"
        number = current?.number ?? "?"
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
    
    func scrape(number: String) async throws -> (Runner, Array<Run>) {
        
        var parkrun_request = URLRequest(url: URL(string: "https://www.parkrun.com.au/parkrunner/\(number)/all/")!)
        
        let html = try await scrape_catch(request: {
            return await String(
                decoding: try DataController.shared.request(body: &parkrun_request),
                as: UTF8.self
            )
        })
        
        return (
            try Runner(context: DataController.shared.container.viewContext, number: number, html: html),
            try Run.from_scrape(context: DataController.shared.container.viewContext, number: number, html: html)
        )
        
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
