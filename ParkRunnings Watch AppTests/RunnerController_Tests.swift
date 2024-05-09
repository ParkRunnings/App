//
//  ParkRunnings_Watch_AppTests.swift
//  ParkRunnings Watch AppTests
//
//  Created by Charlie on 17/9/2022.
//

import XCTest
import CoreData
@testable import ParkRunnings_Watch_App

class RunnerController_Tests: XCTestCase {
    
    struct RunnerTest {
        var number: String
        var name: String? = nil
        var runs: String? = nil
        var fastest: String? = nil
    }
    
    func test_namecased() throws {
        
        let tests: Array<(String, String)> = [
            ("Charlie SCHACHER", "Charlie Schacher"),
            ("Neal JORDAN-CAWS", "Neal Jordan-Caws"),
            ("JOHNO'NEIL", "Johno'Neil"),
            ("JOHNO-'NEIL ", "Johno-'Neil"),
//            ("john oneil'", "John Oneil'")  // Uncovered edge case
        ]
        
        for (before, after) in tests {
            XCTAssertEqual(before.namecased(), after)
        }
        
    }
    
    func test_runner_scrape_normal() async throws {
        
        let tests: Array<(RunnerTest)> = [
            RunnerTest(number: "5470914", name: "Charlie Schacher"),
            RunnerTest(number: "237765", name: "Liam Doyle"),
            RunnerTest(number: "8906", name: "Neal Jordan-Caws"),
            RunnerTest(number: "8569", name: "Sean O'Reilly")
        ]
     
        for test in tests {
            
            let runner_all_html = try await RunnerController.shared.scrape_runner_all_html(number: test.number)
            let runner_summary_html = try await RunnerController.shared.scrape_runner_summary_html(number: test.number)
            
            try await DataController.shared.container.performBackgroundTask({ context in
                
                let (runner, runs) = try RunnerController.shared.convert_html(context: context, number: test.number, runner_all_html: runner_all_html, runner_summary_html: runner_summary_html)
         
                XCTAssertEqual(runner.number, test.number)
                XCTAssertEqual(runner.name, test.name)
                XCTAssertGreaterThan(runs.count, 0)
                XCTAssertNil(runner.error)
                
            })
        
        }
        
    }
    
    func test_runner_scrape_no_runs() async throws {

        let tests: Array<(RunnerTest)> = [
            RunnerTest(number: "34513", name: "Julia Carter", runs: nil, fastest: nil)
        ]

        for test in tests {
            
            let runner_all_html = try await RunnerController.shared.scrape_runner_all_html(number: test.number)
            let runner_summary_html = try await RunnerController.shared.scrape_runner_summary_html(number: test.number)
            
            try await DataController.shared.container.performBackgroundTask({ context in
                
                let (runner, runs) = try RunnerController.shared.convert_html(context: context, number: test.number, runner_all_html: runner_all_html, runner_summary_html: runner_summary_html)
         
                XCTAssertEqual(runner.number, test.number)
                XCTAssertEqual(runner.name, test.name)
                XCTAssertEqual(runs.count, 0)
                XCTAssertNil(runner.error)
                
            })
        
        }

    }

    func test_runner_scrape_fastest() async throws {

        let tests: Array<(RunnerTest)> = [
            RunnerTest(number: "237765", name: "Liam Doyle", fastest: "20:44")
        ]

        for test in tests {
            
            let runner_all_html = try await RunnerController.shared.scrape_runner_all_html(number: test.number)
            let runner_summary_html = try await RunnerController.shared.scrape_runner_summary_html(number: test.number)
            
            try await DataController.shared.container.performBackgroundTask({ context in
                
                let (runner, runs) = try RunnerController.shared.convert_html(context: context, number: test.number, runner_all_html: runner_all_html, runner_summary_html: runner_summary_html)
         
                XCTAssertEqual(runner.number, test.number)
                XCTAssertEqual(runner.name, test.name)
                XCTAssertGreaterThan(runs.count, 0)
                XCTAssertEqual(runs.sorted(by: { $0.time < $1.time}).first!.display_time, test.fastest)
                XCTAssertNil(runner.error)
                
            })
        
        }

    }

    func test_runner_scrape_failing() async throws {

        let tests: Array<RunnerTest> = [
            RunnerTest(number: "1"),
//            RunnerTest(number: "54709140")
        ]

        for test in tests {
            
            let runner_all_html = try await RunnerController.shared.scrape_runner_all_html(number: test.number)
            let runner_summary_html = try await RunnerController.shared.scrape_runner_summary_html(number: test.number)
            
            try await DataController.shared.container.performBackgroundTask({ context in
                
                let (runner, runs) = try RunnerController.shared.convert_html(context: context, number: test.number, runner_all_html: runner_all_html, runner_summary_html: runner_summary_html)
         
                XCTAssertEqual(runner.number, test.number)
                XCTAssertEqual(runner.name, test.name)
                XCTAssertEqual(runs.count, 0)
                XCTAssertNotNil(runner.error)
                
            })
        
        }
        
    }

}
