//
//  RunnerController_Tests.swift
//  ParkRunnings Tests
//
//  Created by Charlie on 12/8/2022.
//

import XCTest
@testable import ParkRunnings_WatchKit_Extension

class RunnerController_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//
//    }
//
    func test_namecased() throws {
        
        let tests: Array<(String, String)> = [
            ("Charlie SCHACHER", "Charlie Schacher"),
            ("Neal JORDAN-CAWS", "Neal Jordan-Caws"),
            ("JOHNO'NEIL", "Johno'Neil"),
            ("JOHNO-'NEIL", "Johno-'Neil"),
//            ("john oneil'", "John Oneil'")  // Uncovered edge case
        ]
        
        for (before, after) in tests {
            XCTAssertEqual(before.namecased(), after)
        }
        
    }
    
    func test_runner_scrape_normal() async throws {
        
        let tests: Array<(String, String)> = [
            ("5470914", "Charlie Schacher"),
            ("237765", "Liam Doyle"),
            ("8906", "Neal Jordan-Caws"),
            ("8569", "Sean O'Reilly")
        ]
     
        for (number, name) in tests {
            
            let runner = try await RunnerController.shared.scrape(number: number)
            
            XCTAssertEqual(runner.number, number)
            XCTAssertEqual(runner.name, name)
            XCTAssertNotNil(runner.runs)
            XCTAssertNotNil(runner.fastest)
            XCTAssertNil(runner.error)
        
        }
        
    }
    
    func test_runner_scrape_no_runs() async throws {
        
        let tests: Array<(String, String)> = [
            ("34513", "Julia Carter")
        ]
        
        for (number, name) in tests {
            
            let runner = try await RunnerController.shared.scrape(number: number)
            
            XCTAssertEqual(runner.number, number)
            XCTAssertEqual(runner.name, name)
            XCTAssertNil(runner.runs)
            XCTAssertNil(runner.fastest)
            XCTAssertNil(runner.error)
        
        }
        
    }
    
    func test_runner_scrape_failing() async throws {
        
        let tests: Array<String> = [
            "1",
            "1000000000"
        ]
        
        for number in tests {
            
            let runner = try await RunnerController.shared.scrape(number: number)
            
            XCTAssertEqual(runner.number, number)
            XCTAssertNil(runner.name)
            XCTAssertNil(runner.runs)
            XCTAssertNil(runner.fastest)
            XCTAssertNotNil(runner.error)
        
        }
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
