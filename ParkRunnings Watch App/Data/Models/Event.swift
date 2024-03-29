//
//  Event.swift
//  ParkRunnings WatchKit Extension
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
    @NSManaged public var start_dst: String
    @NSManaged public var timezone: String
    @NSManaged public var distance: Double
    @NSManaged public var state: UUID
    @NSManaged public var refreshed: Date
    
    static private let CoreName = "Event"
    
    var hour: Int { get { return Int(start.split(separator: ":")[0])! }}
    var minute: Int { get { return Int(start.split(separator: ":")[1])! }}
    
    var hour_dst: Int { get { return Int(start_dst.split(separator: ":")[0])! }}
    var minute_dst: Int { get { return Int(start_dst.split(separator: ":")[1])! }}

    enum CodingKeys: CodingKey {
        case uuid, country, name, latitude, longitude, start, start_dst, timezone, state, refreshed
    }
    
    public init(
        context: NSManagedObjectContext,
        uuid: UUID,
        name: String,
        country: String,
        latitude: Double,
        longitude: Double,
        start: String,
        start_dst: String,
        timezone: String,
        distance: Double,
        state: UUID,
        refreshed: Date
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Event.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.uuid = uuid
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.start = start
        self.start_dst = start_dst
        self.timezone = timezone
        self.distance = distance
        self.state = state
        self.refreshed = refreshed
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        let context = decoder.userInfo[CodingUserInfoKey.context] as! NSManagedObjectContext

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        let uuid = try! container.decode(UUID.self, forKey: .uuid)
        
        self.init(
            context: context,
            uuid: uuid,
            name: try! container.decode(String.self, forKey: .name),
            country: try! container.decode(String.self, forKey: .country),
            latitude: try! container.decode(Double.self, forKey: .latitude),
            longitude: try! container.decode(Double.self, forKey: .longitude),
            start: try! container.decode(String.self, forKey: .start),
            start_dst: try! container.decode(String.self, forKey: .start_dst),
            timezone: try! container.decode(String.self, forKey: .timezone),
            distance: -1,
            state: try! container.decode(UUID.self, forKey: .state),
            refreshed: try! container.decode(Date.self, forKey: .refreshed)
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
    
    func dates() -> (Date, Date) {
        
        func fractional(hour: Int, minute: Int) -> Double {
            // A simple method for representing an time as a fraction
            return Double(hour) + (Double(minute) / 60)
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let timezone = TimeZone(identifier: self.timezone)!
        
        // Reference for day of week Saturday
        let saturday = 7
        
        // Get current date and it's components for the event timezone
        var now = Date.now
        var now_components = calendar.dateComponents(in: timezone, from: now)
        
        let fractional_start = timezone.isDaylightSavingTime(for: Date.now) ? fractional(hour: hour_dst, minute: minute_dst) : fractional(hour: hour, minute: minute)
        
        // If the current date is within an hour of the event starting, roll the current date back a day
        if now_components.weekday! == saturday && fractional_start - fractional(hour: now_components.hour!, minute: now_components.minute!) > -1 {
            now_components.weekday! -= 1
            now_components.hour! -= 1
            now = calendar.date(from: now_components)!
        }
        
        // The date component filters to apply when searching for event dates
        let match_components = DateComponents(
            calendar: calendar,
            timeZone: timezone,
            hour: hour,
            minute: minute,
            second: 0,
            nanosecond: 0,
            weekday: saturday
        )
        
        // Find the next and previous events
        var next = calendar.nextDate(after: now, matching: match_components, matchingPolicy: .nextTime, direction: .forward)!
        var previous = calendar.nextDate(after: now, matching: match_components, matchingPolicy: .nextTime, direction: .backward)!
        
        // If the next event is occuring in DST, switch to DST dates
        if timezone.isDaylightSavingTime(for: next) {
            next = next.update_start(hour: hour_dst, minute: minute_dst)
        }
        
        // If the previous event occured in DST, switch to DST dates
        if timezone.isDaylightSavingTime(for: previous) {
            previous = previous.update_start(hour: hour_dst, minute: minute_dst)
        }
        
        return (previous, next)
        
    }
    
    func time_display() -> String {
        
        let dates = dates()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: dates.1)
        
    }
    
    func time_progress() -> Double {
        
        let dates = dates()
        
        let previous = dates.0
        let next = dates.1
        
        let base = floor(Date.now.timeIntervalSince(previous) / 3600.0) / (next.timeIntervalSince(previous) / 3600.0)
        let scaled = pow(base - 0.005, 3) + 0.02
        
        return scaled
        
    }
 
    func distance_progress() -> Double {
        return pow(1 - (distance / 1000000).clamped(to: 0...1), 50)
    }
    
    func distance_display() -> String {

        func display_fraction(places: Int) -> String {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = places
            formatter.minimumFractionDigits = places
            
            return formatter.string(for: Double(distance)/1000.0)!
            
        }

        switch Int(distance) {

            case 0 ..< 10000:
            return display_fraction(places: 2)

            case 1000 ..< 100000:
            return display_fraction(places: 1)
            
            case 100000 ..< 1000000:
            return display_fraction(places: 0)

            case 1000000 ... Int.max:
            return "999+"
            
            default:
            return "?"
        }
        
    }
    
    
}

class EventMeta: Decodable {
    
    let events: Array<Event>
    let state: UUID
    let refreshed: String
    
    enum CodingKeys: CodingKey {
        case events, state, refreshed
    }
    
    init(events: Array<Event>, state: UUID, refreshed: String) {
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
            state: try! container.decode(UUID.self, forKey: .state),
            refreshed: try! container.decode(String.self, forKey: .refreshed)
        )
        
    }
    
}
