//
//  Map+CoreDataProperties.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 12/6/2022.
//
//

import Foundation
import CoreData


extension Map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var mid: String?
    @NSManaged public var start: NSObject?
    @NSManaged public var finish: NSObject?
    @NSManaged public var route: NSObject?
    @NSManaged public var event: Event?

}

extension Map : Identifiable {

}
