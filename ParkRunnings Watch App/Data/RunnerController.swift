//
//  RunnerController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 8/5/2022.
//

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
    @Published var runs: Int!
    
    @Published var current_milestone: Milestone?
    @Published var next_milestone: Milestone?
    
    override init() {
        
        super.init()
        
        current = self.fetch()
        self.update()
        
    }
    
    func fetch() -> Runner? {
        
        let context = DataController.shared.container.viewContext
        
        guard let number = MetaController.shared.runner_number else { return nil }
        
        let request = Runner.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        
        guard let runner = try! context.fetch(request).first else {
            MetaController.shared.runner_number = nil
            DataController.shared.save()
            return nil
        }
        
        return runner
        
    }
    
    func update() {
        
        name = current?.name ?? "-"
        number = current?.number ?? "?"
        a_number = current?.a_number ?? "A?"
        
        results_sorted = current?.results_sorted ?? []
        results_fastest = current?.results_fastest ?? []
        
        fastest = results_fastest.first
        latest = results_sorted.last
        runs = results_sorted.count
        
        current_milestone = Milestone.current(runs: runs)
        next_milestone = Milestone.next(runs: runs)
        
    }
    
    func scrape(number: String) async throws -> Runner {
        
        var parkrun_request = URLRequest(url: URL(string: "https://www.parkrun.com.au/parkrunner/\(number)/all/")!)
        
        let html = try await scrape_catch(request: {
            return await String(
                decoding: try DataController.shared.request(body: &parkrun_request),
                as: UTF8.self
            )
        })
        
        return try Runner(context: DataController.shared.container.viewContext, number: number, html: html)
        
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
