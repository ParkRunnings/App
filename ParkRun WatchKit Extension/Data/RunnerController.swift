//
//  RunnerController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 8/5/2022.
//

import CoreData

class RunnerController: NSObject, ObservableObject {
    
    static let shared = RunnerController()
    
    func scrape(number: String) async throws -> Runner {
        
        let html = try await scrape_catch(request: {
            return await String(
                decoding: try DataController.shared.request(body: URLRequest(url: URL(string: "https://www.parkrun.com.au/parkrunner/\(number)/all/")!)),
                as: UTF8.self
            )
        })
        
        var request = URLRequest(url: URL(string: "https://australia-southeast1-park-run.cloudfunctions.net/get_runner_remote")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        request.httpBody = try! JSONEncoder().encode([
            "content": html,
            "number": number
        ])
        
        return try await scrape_catch(request: {
            return try await DataController.shared.json(body: request, as: Runner.self)
        })
        
    }
    
    private func scrape_catch<T>(request: () async throws -> T) async throws -> T {
        
        do {
            return try await request()
        } catch let error as URLError {

            switch error.code {

                case .notConnectedToInternet:
                throw RunnerControllerError.scrape(title: "Network Offline")

                default:
                throw RunnerControllerError.scrape(title: "Unknown Network Error")

            }

        } catch {
            throw RunnerControllerError.scrape(title: "Unknown Error")
        }
      
    }

}
