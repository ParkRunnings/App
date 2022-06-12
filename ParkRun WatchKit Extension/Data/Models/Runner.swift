//
//  Runner.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData

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
