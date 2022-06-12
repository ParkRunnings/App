//
//  DataController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "ParkRun")
    
    init() {
        
        container.loadPersistentStores(completionHandler: { description, error in
            
            if let error = error {
                print("DataController for ParkRun failed to load: \(error.localizedDescription)")
            }
            
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

    }
    
    func request(body: URLRequest) async throws -> Data {
            
        let (response, _) = try await URLSession.shared.data(for: body)
        
        return response
        
    }

    func json<T: Decodable>(body: URLRequest, as: T.Type) async throws -> T {
        
        let response = try await request(body: body)
        
        print(String(data: response, encoding: .utf8)!)
        
        let context = DataController.shared.container.viewContext
                
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context] = context
                
        let data = try! decoder.decode(T.self, from: response)
                
        return data
        
    }
    
    func save() {
        
        // Exit out of CoreData save if running in preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return }
        
        let context = container.viewContext

        if context.hasChanges {
            try! context.save()
        }
        
    }
    
}

//struct PersistenceController {
//    // A singleton for our entire app to use
//    static let shared = PersistenceController()
//
//    // Storage for Core Data
//    let container: NSPersistentContainer
//
//    // A test configuration for SwiftUI previews
//    static var preview: PersistenceController = {
//        let controller = PersistenceController(inMemory: true)
//
//        // Create 10 example programming languages.
//        for _ in 0..<10 {
//            let language = ProgrammingLanguage(context: controller.container.viewContext)
//            language.name = "Example Language 1"
//            language.creator = "A. Programmer"
//        }
//
//        return controller
//    }()
//
//    // An initializer to load Core Data, optionally able
//    // to use an in-memory store.
//    init(inMemory: Bool = false) {
//        // If you didn't name your model Main you'll need
//        // to change this name below.
//        container = NSPersistentContainer(name: "Main")
//
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
//
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
