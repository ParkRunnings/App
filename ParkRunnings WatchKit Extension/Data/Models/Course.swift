//
//  Course.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 12/6/2022.
//

import Foundation
import CoreData

@objc(Course)
public class Course: NSManagedObject, Identifiable, Decodable {
    
    @NSManaged public var uuid: UUID
    @NSManaged public var mid: String
    @NSManaged public var start: Array<Double>
    @NSManaged public var finish: Array<Double>
    @NSManaged public var route: Array<Array<Double>>
    @NSManaged public var image: Bool
    @NSManaged public var state: String
    @NSManaged public var refreshed: Date
    
    static private let CoreName = "Course"
    
    enum CodingKeys: CodingKey {
        case uuid, mid, start, finish, route, image, state, refreshed
    }
    
    public init(
        context: NSManagedObjectContext,
        uuid: UUID,
        mid: String,
        start: Array<Double>,
        finish: Array<Double>,
        route: Array<Array<Double>>,
        image: Bool,
        state: String,
        refreshed: Date
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Course.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.uuid = uuid
        self.mid = mid
        self.start = start
        self.finish = finish
        self.route = route
        self.image = image
        self.state = state
        self.refreshed = refreshed
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        let context = decoder.userInfo[CodingUserInfoKey.context] as! NSManagedObjectContext

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        let uuid = try! container.decode(UUID.self, forKey: .uuid)
        let _ = CourseImage(context: context, uuid: uuid, data: Data(base64Encoded: try! container.decode(String.self, forKey: .image))!)
        
        self.init(
            context: context,
            uuid: uuid,
            mid: try! container.decode(String.self, forKey: .mid),
            start: try! container.decode(Array<Double>.self, forKey: .start),
            finish: try! container.decode(Array<Double>.self, forKey: .finish),
            route: try! container.decode(Array<Array<Double>>.self, forKey: .route),
            image: true,
            state: try! container.decode(String.self, forKey: .state),
            refreshed: try! container.decode(Date.self, forKey: .refreshed)
        )
        
    }
           
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: Course.CoreName)
    }
    
}
