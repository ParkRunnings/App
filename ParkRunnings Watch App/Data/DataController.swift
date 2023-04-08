//
//  DataController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import CoreData

struct DataRequest {
    
    let url: URL
    var header: Dictionary<String, String>
    var timeout: Double = 10
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
}

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let container = NSPersistentContainer(name: "ParkRunnings")
    
    init() {
        
        container.loadPersistentStores(completionHandler: { description, error in
            
            if let error = error {
                print("DataController for ParkRunnings failed to load: \(error.localizedDescription)")
            }
            
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    }
    
    func request(url: URL, header: Dictionary<String, String> = [:], cache: URLRequest.CachePolicy = .useProtocolCachePolicy) async throws -> Data {
        
        var body = URLRequest(url: url)
        body.timeoutInterval = 10
        body.cachePolicy = cache
        
        for (header, value) in header {
            body.addValue(value, forHTTPHeaderField: header)
        }
        
        let (response, _) = try await URLSession.shared.data(for: body)
        
        return response
        
    }
    
    func json<T: Decodable>(url: URL, header: Dictionary<String, String> = [:], cache: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData, as: T.Type) async throws -> T {
        
        let json_header = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let response = try await request(
            url: url,
            header: json_header.merging(header, uniquingKeysWith: { (x, _) in x }),
            cache: cache
        )
        
        let context = DataController.shared.container.viewContext
                
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context] = context
        decoder.dateDecodingStrategy = .iso8601
                
        return try! decoder.decode(T.self, from: response)
               
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
