//
//  Run.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import SwiftSoup

@objc(Run)
public class Run: NSManagedObject, Identifiable {

    @NSManaged public var date: Date
    @NSManaged public var event: String
    @NSManaged public var position: Int16
    @NSManaged public var time: Int16
    @NSManaged public var runner: Runner
    
    static private let CoreName = "Run"
    
    public init(
        context: NSManagedObjectContext,
        date: Date,
        event: String,
        position: Int16,
        time: Int16
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Run.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.date = date
        self.event = event
        self.position = position
        self.time = time
        
    }
//
//    convenience public init(context: NSManagedObjectContext, number: String, error: String) {
//
//        let existing = Runner.fetch(context: context, number: number)
//
//        self.init(
//            context: context,
//            number: number,
//            name: existing?.name,
//            runs: existing?.runs,
//            fastest: existing?.fastest,
//            error: error,
//            created: existing?.created ?? Date.now,
//            refreshed: existing?.refreshed
//        )
//
//    }
       
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: Run.CoreName)
    }

//    static func fetch(context: NSManagedObjectContext, number: String) -> Result? {
//
//        let request = Result.request()
//        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number])
//
//        return try? context.fetch(request).first
//
//    }
    
}
