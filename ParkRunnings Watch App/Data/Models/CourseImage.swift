//
//  CourseImage.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 21/6/2022.
//

import Foundation
import CoreData

@objc(CourseImage)
public class CourseImage: NSManagedObject, Identifiable {
    
    @NSManaged public var uuid: UUID
    @NSManaged public var data: Data
    
    static private let CoreName = "CourseImage"

    public init(
        context: NSManagedObjectContext,
        uuid: UUID,
        data: Data
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: CourseImage.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.uuid = uuid
        self.data = data
        
    }
      
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<CourseImage> {
        return NSFetchRequest<CourseImage>(entityName: CourseImage.CoreName)
    }
    
}
