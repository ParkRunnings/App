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
    
    @Published var number: String!
    @Published var a_number: String!
    @Published var name: String!
    
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
        
        number = current?.number ?? "?"
        a_number = current?.a_number ?? "A?"
        name = current?.name ?? "-"
       
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
