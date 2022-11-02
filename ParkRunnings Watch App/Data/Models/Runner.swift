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
    @NSManaged public var error: String?
    @NSManaged public var created: Date
    @NSManaged public var refreshed: Date?
    
    var a_number: String { get { return "A\(number)" }}
    var display_name: String { get { return name ?? "Unknown Runner" }}
    
    static private let CoreName = "Runner"
    
    public init(
        context: NSManagedObjectContext,
        number: String,
        name: String?,
        error: String?,
        created: Date,
        refreshed: Date?
    ) {
        
        let entity = NSEntityDescription.entity(forEntityName: Runner.CoreName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.number = number
        self.name = name
        self.error = error
        self.created = created
        self.refreshed = refreshed
        
    }

    convenience public init(context: NSManagedObjectContext, number: String, html: String) throws {
        
        let existing = Runner.fetch(context: context, number: number)
        let soup = try SwiftSoup.parse(html)
        
        var name: String?
        var scrape_error: String?
        
        do {
            
            if let raw_name = try soup.select("h2").first()?.text().namecased(), raw_name != "" {
                name = raw_name
            } else {
                throw RunnerControllerError.scrape(title: "No name")
            }
            
            _ = try Run.from_scrape(context: context, number: number, html: html)
            
        } catch {
            scrape_error = "A scraping error occured."
        }
        
        self.init(
            context: context,
            number: number,
            name: name ?? existing?.name,
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
