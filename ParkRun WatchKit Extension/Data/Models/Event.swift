//
//  Event.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import CoreLocation

@objc(Event)
public class Event: NSManagedObject, Identifiable, Decodable {

    @NSManaged public var uuid: UUID
    @NSManaged public var name: String
    @NSManaged public var country: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var start: String
    @NSManaged public var timezone: String
    @NSManaged public var distance: Double
    
    static private let CoreName = "Event"
    
    enum CodingKeys: CodingKey {
        case uuid, country, name, latitude, longitude, start, timezone
    }
    
    public init(
        context: NSManagedObjectContext,
        uuid: UUID,
        name: String,
        country: String,
        latitude: Double,
        longitude: Double,
        start: String,
        timezone: String,
        distance: Double
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Event.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.uuid = uuid
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.start = start
        self.timezone = timezone
        self.distance = distance
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        let context = decoder.userInfo[CodingUserInfoKey.context] as! NSManagedObjectContext

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        self.init(
            context: context,
            uuid: try! container.decode(UUID.self, forKey: .uuid),
            name: try! container.decode(String.self, forKey: .name),
            country: try! container.decode(String.self, forKey: .country),
            latitude: try! container.decode(Double.self, forKey: .latitude),
            longitude: try! container.decode(Double.self, forKey: .longitude),
            start: try! container.decode(String.self, forKey: .start),
            timezone: try! container.decode(String.self, forKey: .timezone),
            distance: -1
        )
        
    }
           
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: Event.CoreName)
    }
    
    public func coordinates() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
}

class EventMeta: Decodable {
    
    let events: Array<Event>
    let state: String
    let refreshed: String
    
    enum CodingKeys: CodingKey {
        case events, state, refreshed
    }
    
    init(events: Array<Event>, state: String, refreshed: String) {
        self.events = events
        self.state = state
        self.refreshed = refreshed
    }
    
    required convenience public init(from decoder: Decoder) throws {

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        self.init(
            events: try! container.decode(Array<Event>.self, forKey: .events),
            state: try! container.decode(String.self, forKey: .state),
            refreshed: try! container.decode(String.self, forKey: .refreshed)
        )
        
    }
    
}
