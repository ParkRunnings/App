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
    let user_agent = "Mozilla/5.0 (iPhone14,3; U; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/19A346 Safari/602.1"
    
    init() {
        
        if let in_memory = ProcessInfo.processInfo.environment["COREDATA_IN_MEMORY"], in_memory == "1" {
            
            print("Using in memory CoreData container")
            
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            
            container.persistentStoreDescriptions = [description]
            
        }
        
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
    
    func json<T: Decodable>(url: URL, header: Dictionary<String, String> = [:], cache: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, as: T.Type) async throws -> T {
        
        print(url)
        
        let json_header = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let response = try await request(
            url: url,
            header: json_header.merging(header, uniquingKeysWith: { (x, _) in x }),
            cache: cache
        )
        
        print(String(decoding: response, as: UTF8.self).prefix(100) + "...")
        
        return await DataController.shared.container.performBackgroundTask({ context in
        
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            decoder.dateDecodingStrategy = .iso8601
               
            let object = try! decoder.decode(T.self, from: response)
            
            DataController.shared.save(context: context)
            
            return object
            
        })
        
    }
    
    func json2(url: URL, header: Dictionary<String, String> = [:], cache: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData) async throws -> Data {
        
        print(url)
        
        let json_header = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let response = try await request(
            url: url,
            header: json_header.merging(header, uniquingKeysWith: { (x, _) in x }),
            cache: cache
        )
        
        print(String(decoding: response, as: UTF8.self).prefix(100) + "...")
        
        return response
        
    }
    
    func save(context: NSManagedObjectContext? = nil) {
        
        // Exit out of CoreData save if running in preview
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return }

        let context = context ?? DataController.shared.container.viewContext
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if context.hasChanges {
            try! context.save()
        }
        
    }
    
}
