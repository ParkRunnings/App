//
//  Meta.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import Foundation
import CoreData
import CoreLocation

@objc(Meta)
public class Meta: NSManagedObject, Identifiable, Refreshable {
    
    @NSManaged public var id: String
    @NSManaged public var launches: Int32
    @NSManaged public var created: Date
    @NSManaged public var setup: Bool
    @NSManaged public var event_master: UUID?
    @NSManaged public var event_home: UUID?
    @NSManaged public var runner_number: String?
    
    static private let CoreName = "Meta"
    
    public init(
        context: NSManagedObjectContext,
        id: String,
        launches: Int32,
        created: Date,
        setup: Bool,
        event_master: UUID?,
        event_home: UUID?,
        runner_number: String?
    ) {
        
        super.init(
            entity: NSEntityDescription.entity(forEntityName: Meta.CoreName, in: context)!,
            insertInto: context
        )
        
        self.id = id
        self.launches = launches
        self.created = created
        self.event_master = event_master
        self.event_home = event_home
        self.runner_number = runner_number
 
    }
//
//    private init() {
//
//        super.init(entity: NSEntityDescription(
//
//            .entity(forEntityName: <#T##String#>, in: <#T##NSManagedObjectContext#>), insertInto: nil)
//
//        self.id = "loading-meta"
//        self.launches = 0
//        self.created = Date.now
//        self.setup = false
//        self.event_master = nil
//        self.event_home = nil
//        self.runner_number = nil
//
//    }
//
    convenience init(
        context: NSManagedObjectContext,
        id: String
    ) {
        
        self.init(
            context: context,
            id: id,
            launches: 0,
            created: Date.now,
            setup: false,
            event_master: nil,
            event_home: nil,
            runner_number: nil
        )
        
    }
   
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Meta> {
        return NSFetchRequest<Meta>(entityName: Meta.CoreName)
    }
    
}
