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
    @NSManaged public var fastest: String?
    @NSManaged public var runs: String?
    @NSManaged public var created: Date
    
    var a_number: String {
        get {
            return "A\(number)"
        }
    }
    
    static private let CoreName = "Runner"
    
    enum CodingKeys: CodingKey {
        case number, name, fastest, runs, created
    }
    
    public init(
        context: NSManagedObjectContext,
        number: String,
        name: String?,
        fastest: String?,
        runs: String?,
        created: Date = Date.now
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Runner", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.number = number
        self.name = name
        self.fastest = fastest
        self.runs = runs
        self.created = created
        
    }
        
    required convenience public init(from decoder: Decoder) throws {
        
        let context = decoder.userInfo[CodingUserInfoKey.context] as! NSManagedObjectContext

        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            fatalError()
        }
        
        self.init(
            context: context,
            number: try! container.decode(String.self, forKey: .number),
            name: try! container.decode(String.self, forKey: .name),
            fastest: try? container.decode(String.self, forKey: .fastest),
            runs: try? container.decode(String.self, forKey: .runs)
        )
        
    }
           
    @objc
    override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    @nonobjc public class func request() -> NSFetchRequest<Runner> {
        return NSFetchRequest<Runner>(entityName: Runner.CoreName)
    }
    
}
