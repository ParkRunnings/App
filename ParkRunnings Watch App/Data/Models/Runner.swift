//
//  Runner.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import SwiftSoup

@objc(Runner)
public class Runner: NSManagedObject, Identifiable {

    @NSManaged public var number: String
    @NSManaged public var name: String?
    @NSManaged public var runs: String?
    @NSManaged public var fastest: String?
    @NSManaged public var error: String?
    @NSManaged public var created: Date
    @NSManaged public var refreshed: Date?
    @NSManaged public var results: Array<Run>
    
    var a_number: String { get { return "A\(number)" }}
    var display_name: String { get { return name ?? "Unknown Runner" }}
    var display_runs: String { get { return runs ?? "-" }}
    var display_fastest: String { get { return fastest ?? "-" }}
    
    static private let CoreName = "Runner"
    
    public init(
        context: NSManagedObjectContext,
        number: String,
        name: String?,
        runs: String?,
        fastest: String?,
        error: String?,
        created: Date,
        refreshed: Date?,
        results: Array<Run>
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Runner.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.number = number
        self.name = name
        self.runs = runs
        self.fastest = fastest
        self.error = error
        self.created = created
        self.refreshed = refreshed
        self.results = results
        
    }

    convenience public init(context: NSManagedObjectContext, number: String, html: String) throws {
        
        let existing = Runner.fetch(context: context, number: number)
        let soup = try SwiftSoup.parse(html)
        
        var name: String?
        var runs: String?
        var fastest: String?
        var scrape_error: String?
        var results: Array<Run> = []
        
        do {
            
            if let raw_name = try soup.select("h2").first()?.text().namecased(), raw_name != "" {
                name = raw_name
            } else {
                throw RunnerControllerError.scrape(title: "No name")
            }
            
            if let raw_runs = try soup.select("h3").first()?.text().strip(), let regex_match = try NSRegularExpression(pattern: "(\\d+)").firstMatch(in: raw_runs, range: NSRange(location: 0, length: raw_runs.utf16.count)) {
                runs = String(raw_runs[Range(regex_match.range, in: raw_runs)!])
            }
            
            if let raw_tables = try? soup.select("table"),
               let raw_table = raw_tables.filter({ (try? $0.select("caption").text().strip()) ?? "" == "Summary Stats for All Locations" }).first,
               let raw_column = try? raw_table.select("thead").first()?.select("tr").first()?.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Fastest"),
               let raw_row = try? raw_table.select("tbody").select("tr").map({ try? $0.select("td").first()?.text().strip() }).firstIndex(of: "Time"),
               let raw_fastest = try? raw_table.select("tbody").select("tr")[raw_row].select("td")[raw_column].text().strip() {
                fastest = raw_fastest
            }
            
            if let raw_tables = try? soup.select("table"),
               let raw_table = raw_tables.filter({ (try? $0.select("caption").text().strip()) ?? "" == "All Results" }).first,
               let raw_header = try? raw_table.select("thead").first()?.select("tr").first(),
               let date_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Run Date"),
               let event_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Event"),
               let position_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Pos"),
               let time_index = try? raw_header.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Time"),
               let raw_rows = try? raw_table.select("tbody").select("tr") {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/mm/yyyy"
                
                for row in raw_rows {
                   
                    if let elements = try? row.select("td"),
                       let date = try? formatter.date(from: elements[date_index].text().strip()),
                       let event = try? elements[event_index].text().strip(),
                       let raw_position = try? elements[position_index].text().strip(),
                       let position = Int16(raw_position),
                       let components = try? elements[time_index].text().strip().split(separator: ":").map({ Int($0)! })
                    {
                     
                        let hours: Int = components.count == 3 ? components[0] : 0
                        let minutes: Int = components[1]
                        let seconds: Int = components[2]
                        
                        results.append(Run(
                            context: context,
                            date: date,
                            event: event,
                            position: position,
                            time: Int16((hours * 3600) + (minutes * 60) + (seconds))
                        ))
                        
                    }
                    
                }
                
            }
            
        } catch {
            scrape_error = "A scraping error occured."
        }
        
        self.init(
            context: context,
            number: number,
            name: name ?? existing?.name,
            runs: runs ?? existing?.runs,
            fastest: fastest ?? existing?.fastest,
            error: scrape_error,
            created: existing?.created ?? Date.now,
            refreshed: Date.now,
            results: results
        )
        
    }
    
    convenience public init(context: NSManagedObjectContext, number: String, error: String) {
        
        let existing = Runner.fetch(context: context, number: number)
        
        self.init(
            context: context,
            number: number,
            name: existing?.name,
            runs: existing?.runs,
            fastest: existing?.fastest,
            error: error,
            created: existing?.created ?? Date.now,
            refreshed: existing?.refreshed,
            results: existing?.results ?? []
        )
        
    }
           
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Runner> {
        return NSFetchRequest<Runner>(entityName: Runner.CoreName)
    }

    static func fetch(context: NSManagedObjectContext, number: String) -> Runner? {
        
        let request = Runner.request()
        request.predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        
        return try? context.fetch(request).first
        
    }
    
}
