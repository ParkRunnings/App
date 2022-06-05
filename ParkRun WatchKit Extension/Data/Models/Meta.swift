//
//  Meta.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import Foundation
import CoreData
import CoreLocation

@objc(Meta)
public class Meta: NSManagedObject, Identifiable {
    
    @NSManaged public var id: String
    @NSManaged public var setup: Bool
    @NSManaged public var launches: Int32
    @NSManaged public var created: Date
    @NSManaged public var event_master: String?
    @NSManaged public var event_home: UUID?
    @NSManaged public var runner_number: String?
    
    static private let CoreName = "Meta"
    
    public init(
        context: NSManagedObjectContext,
        id: String,
        setup: Bool,
        launches: Int32,
        created: Date,
        event_master: String? = nil,
        event_home: UUID? = nil,
        runner_number: String? = nil
    ) {
        
        super.init(
            entity: NSEntityDescription.entity(forEntityName: Meta.CoreName, in: context)!,
            insertInto: context
        )
        
        self.id = id
        self.setup = setup
        self.launches = launches
        self.created = created
        self.event_master = event_master
        self.event_home = event_home
        self.runner_number = runner_number
        
    }
   
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Meta> {
        return NSFetchRequest<Meta>(entityName: Meta.CoreName)
    }
    
}
