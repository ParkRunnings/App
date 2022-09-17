//
//  DataController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "ParkRunnings")
    
    init() {
        
        container.loadPersistentStores(completionHandler: { description, error in
            
            if let error = error {
                print("DataController for ParkRunnings failed to load: \(error.localizedDescription)")
            }
            
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

    }
    
    func request(body: inout URLRequest) async throws -> Data {
        
        body.timeoutInterval = 10
        
        let (response, _) = try await URLSession.shared.data(for: body)
        
        return response
        
    }
    
    func json<T: Decodable>(request body: inout URLRequest, as: T.Type) async throws -> T {
        
        body.addValue("application/json", forHTTPHeaderField: "Content-Type")
        body.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let response = try await request(body: &body)
        
        let context = DataController.shared.container.viewContext
                
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context] = context
        decoder.dateDecodingStrategy = .iso8601
                
        return try! decoder.decode(T.self, from: response)
               
    }
    
    func json<T: Decodable>(url: String, as: T.Type) async throws -> T {
        
        var request = URLRequest(url: URL(string: url)!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return try! await self.json(request: &request, as: T.self)
        
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
