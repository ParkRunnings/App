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
    
    @NSManaged public var number: String
    @NSManaged public var date: Date
    @NSManaged public var event: String
    @NSManaged public var position: Int16
    @NSManaged public var time: Int16
    @NSManaged public var pb: Bool
    @NSManaged public var streak: Int16
    
    var display_time: String {
        get {
            return "\((time / 60).leading_zeros(width: 2)):\((time % 60).leading_zeros(width: 2))"
        }
    }
    
    var display_date: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yy"
            return formatter.string(from: date)
        }
    }
    
    static private let CoreName = "Run"
    
    public init(
        context: NSManagedObjectContext,
        number: String,
        date: Date,
        event: String,
        position: Int16,
        time: Int16,
        pb: Bool,
        streak: Int16
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Run.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.number = number
        self.date = date
        self.event = event
        self.position = position
        self.time = time
        self.streak = streak
        self.pb = pb
        
    }
    
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @nonobjc public class func request() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: Run.CoreName)
    }
    
}
