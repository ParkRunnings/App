//
//  Runner.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import SwiftSoup

@objc(Runner)
public class Runner: NSManagedObject, Identifiable, Decodable {

    @NSManaged public var number: String
    @NSManaged public var name: String?
    @NSManaged public var runs: String?
    @NSManaged public var fastest: String?
    @NSManaged public var error: String?
    @NSManaged public var created: Date
    @NSManaged public var refreshed: Date?
    
    var a_number: String { get { return "A\(number)" }}
    var display_name: String { get { return name ?? "Unknown Runner" }}
    var display_runs: String { get { return runs ?? "-" }}
    var display_fastest: String { get { return fastest ?? "-" }}
    
    static private let CoreName = "Runner"
    
    enum CodingKeys: CodingKey {
        case number, name, fastest, runs, error
    }
    
    public init(
        context: NSManagedObjectContext,
        number: String,
        name: String?,
        runs: String?,
        fastest: String?,
        error: String?,
        created: Date,
        refreshed: Date?
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
        
    }

    required convenience public init(from decoder: Decoder) throws {
        
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        let number = try container.decode(String.self, forKey: .number)
        
        let context = decoder.userInfo[CodingUserInfoKey.context] as! NSManagedObjectContext
        let existing = Runner.fetch(context: context, number: number)
        
        self.init(
            context: context,
            number: number,
            name: (try? container.decode(String.self, forKey: .name)) ?? existing?.name,
            runs: (try? container.decode(String.self, forKey: .runs)) ?? existing?.runs,
            fastest: (try? container.decode(String.self, forKey: .fastest)) ?? existing?.fastest,
            error: try? container.decode(String.self, forKey: .error),
            created: existing?.created ?? Date.now,
            refreshed: Date.now
        )
        
    }
    
    
    
    convenience public init(context: NSManagedObjectContext, number: String, html: String) throws {
        
        // Test Cases: 8906
        // Test: 34513
        // Test: 5129578
        // Test: 8569
        
        let existing = Runner.fetch(context: context, number: number)
        let soup = try SwiftSoup.parse(html)
        
        var name: String?
        var runs: String?
        var fastest: String?
        var scrape_error: String?
        
        do {
            
            if let raw_name = try soup.select("h2").first()?.text().namecased() {
                name = raw_name
            } else {
                throw RunnerControllerError.scrape(title: "No name")
            }
            
            if let raw_runs = try soup.select("h3").first()?.text().strip(), let regex_match = try NSRegularExpression(pattern: "(\\d+)").firstMatch(in: raw_runs, range: NSRange(location: 0, length: raw_runs.utf16.count)) {
                runs = String(raw_runs[Range(regex_match.range, in: raw_runs)!])
            } else {
                throw RunnerControllerError.scrape(title: "No run count")
            }
            
            if let raw_tables = try? soup.select("table"),
               let raw_table = raw_tables.filter({ (try? $0.select("caption").text().strip()) ?? "" == "Summary Stats for All Locations" }).first,
               let raw_column = try? raw_table.select("thead").first()?.select("tr").first()?.select("th").map({ try? $0.text().strip() }).firstIndex(of: "Fastest"),
               let raw_row = try? raw_table.select("tbody").select("tr").map({ try? $0.select("td").first()?.text().strip() }).firstIndex(of: "Time"),
               let raw_fastest = try? raw_table.select("tbody").select("tr")[raw_row].select("td")[raw_column].text().strip() {
                fastest = raw_fastest
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
            refreshed: Date.now
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
            refreshed: existing?.refreshed
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
