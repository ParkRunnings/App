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
    
    static public func from_scrape(context: NSManagedObjectContext, number: String, html: String) throws -> Array<Run> {
        
        let soup = try SwiftSoup.parse(html)
            
        var runs: Array<Run> = []
        
        if let raw_tables = try? soup.select("table"),
           let raw_table = raw_tables.filter({ (try? $0.select("caption").text().strip()) ?? "" == "All Results" }).first,
           let raw_header = try? raw_table.select("thead").first()?.select("tr").first(),
           let date_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Run Date"),
           let event_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Event"),
           let position_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Pos"),
           let time_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Time"),
           let raw_rows = try? raw_table.select("tbody").select("tr") {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm:ssZ"
            
            var fastest: Int16? = nil
            var last_run: Date? = nil
            var streak: Int16 = 1
            
            for (date, row) in raw_rows.map({ (formatter.date(from: (try? $0.select("td")[date_index].text().strip() + " 00:00:00+0000") ?? ""), $0) }).filter({ $0.0 != nil }).sorted(by: { $0.0! < $1.0! }) {
             
                if let date = date,
                   let elements = try? row.select("td"),
                   let event = try? elements[event_index].text().strip(),
                   let raw_position = try? elements[position_index].text().strip(),
                   let position = Int16(raw_position),
                   var components = try? elements[time_index].text().strip().split(separator: ":").map({ Int($0)! }) {
                    
                    let hours = components.count == 3 ? components.remove(at: 0) : 0
                    let minutes = components.remove(at: 0)
                    let seconds = components.remove(at: 0)
                    
                    let time = Int16((hours * 3600) + (minutes * 60) + (seconds))
                    var pb: Bool = false
                    
                    if fastest ?? Int16.max > time {
                        fastest = time
                        pb = true
                    }
                    
                    if (date - (last_run ?? Date(timeIntervalSince1970: TimeInterval(0)))) / 86_400 < 14 {
                        streak += 1
                    } else {
                        streak = 1
                    }
                    
                    runs.append(Run(
                        context: context,
                        number: number,
                        date: date,
                        event: event,
                        position: position,
                        time: time,
                        pb: pb,
                        streak: streak
                    ))
                    
                    last_run = date
                 
                }
                
            }
            
        }
        
        return runs
        
    }
    
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @nonobjc public class func request() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: Run.CoreName)
    }
    
}
