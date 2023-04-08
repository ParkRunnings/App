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
    
    static public func from_scrape(context: NSManagedObjectContext, number: String, all_events_html: String, summary_events_html: String) throws -> Array<Run> {
        
        let scrape_mapping: Array<(Document, Dictionary<String, String>)> = [(
            try SwiftSoup.parse(summary_events_html),
            [
                "title": "Most Recent parkruns",
                "title_tag": "h3",
                "date": "Run Date",
                "event": "Event",
                "position": "Overall Position",
                "time": "Time"
            ]
        ), (
            try SwiftSoup.parse(all_events_html),
            [
                "title": "All Results",
                "title_tag": "caption",
                "date": "Run Date",
                "event": "Event",
                "position": "Pos",
                "time": "Time"
            ]
        )]
        
        var runs: Array<Run> = []
        var dates: Set<Date> = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ssZ"
        
        for (soup, mapping) in scrape_mapping {
            
            if let raw_divs = try? soup.select("div#content").first()?.select("div"),
               let raw_table = try? raw_divs.filter({ (try? $0.select(mapping["title_tag"]!).text().strip()) ?? "" == mapping["title"] }).first?.select("table").first,
               let raw_header = try? raw_table.select("thead").first()?.select("tr").first(),
               let date_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: mapping["date"]),
               let event_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: mapping["event"]),
               let position_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: mapping["position"]),
               let time_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: mapping["time"]),
               let raw_rows = try? raw_table.select("tbody").select("tr") {
         
                for (date, row) in raw_rows.map({ (formatter.date(from: (try? $0.select("td")[date_index].text().strip() + " 00:00:00+0000") ?? ""), $0) }) {
                 
                    if let date = date, dates.contains(date) { continue }
                    
                    if let date = date,
                       let elements = try? row.select("td"),
                       let event = try? elements[event_index].text().replacingOccurrences(of: "parkrun", with: "").strip(),
                       let raw_position = try? elements[position_index].text().strip(),
                       let position = Int16(raw_position),
                       var components = try? elements[time_index].text().strip().split(separator: ":").map({ Int($0)! }) {
                        
                        dates.insert(date)
                        
                        let hours = components.count == 3 ? components.remove(at: 0) : 0
                        let minutes = components.remove(at: 0)
                        let seconds = components.remove(at: 0)
                        
                        let time = Int16((hours * 3600) + (minutes * 60) + (seconds))
                        
                        runs.append(Run(
                            context: context,
                            number: number,
                            date: date,
                            event: event,
                            position: position,
                            time: time,
                            pb: false,
                            streak: 1
                        ))
                        
                    }
                    
                }
                
            }
           
        }
        
        var fastest: Int16? = nil
        var last_run: Date? = nil
        var streak: Int16 = 1
        
        for run in runs.sorted(by: { $0.date < $1.date }) {
            
            if fastest ?? Int16.max > run.time {
                fastest = run.time
                run.pb = true
            }
            
            if (run.date - (last_run ?? Date(timeIntervalSince1970: TimeInterval(0)))) / 86_400 < 14 {
                streak += 1
                run.streak = streak
            } else {
                streak = 1
            }
            
            last_run = run.date
            
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
