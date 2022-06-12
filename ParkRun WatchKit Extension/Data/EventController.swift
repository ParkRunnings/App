//
//  LocationController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import CoreLocation

class EventController: NSObject, ObservableObject {

    static let shared = EventController()
    
    var current: Event?
//    private var progress_refresh = Timer()
    
    @Published var name: String!
    @Published var distance: Double!
    @Published var start: String!
    
    @Published var time_progress: Double!
    @Published var distance_progress: Double!
    @Published var distance_display: String!
    
//    @NSManaged public var uuid: UUID
//    @NSManaged public var name: String
//    @NSManaged public var country: String
//    @NSManaged public var latitude: Double
//    @NSManaged public var longitude: Double
//    @NSManaged public var start: String
//    @NSManaged public var timezone: String
//    @NSManaged public var distance: Double
    
    override init() {
        super.init()
        
        current = self.fetch()
        self.update()
        
        // To-Do: Possibly pause/delete this timer when moving into background?
        // https://stackoverflow.com/questions/27687240/pausing-timer-when-app-is-in-background-state-swift#answer-56837094
//        progress_refresh = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
//            DispatchQueue.main.async(execute: {
//                if let current = self.current {
//                    self.time_progress = current.time_progress()
//                }
//            })
//        })
        
        if MetaController.shared.event_master == nil {
            
            let context = DataController.shared.container.viewContext
            
            let json = try! Data(contentsOf: Bundle.main.url(forResource: "master", withExtension: "json")!)

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context

            let data = try! decoder.decode(EventMeta.self, from: json)
            MetaController.shared.event_master = data.state
            
            DataController.shared.save()
            
            print("Loaded master data from local")
            
        }
        
    }
    
    func fetch() -> Event? {
        
        let context = DataController.shared.container.viewContext
        
        guard let home = MetaController.shared.event_home else { return nil }
        
        let request = Event.request()
        request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [home])
        
        guard let event = try! context.fetch(request).first else {
            MetaController.shared.event_home = nil
            DataController.shared.save()
            return nil
        }
        
        return event
        
    }
    
    func update() {
        
        name = current?.name ?? "-"
        distance = current?.distance ?? 0
        start = current?.start ?? "?"
        
        time_progress = current?.time_progress() ?? 0.0
        distance_progress = current?.distance_progress() ?? 0.0
        distance_display = current?.distance_display() ?? "?"
    
    }

    func update_distance(current: CLLocation) {
        
        let context = DataController.shared.container.viewContext
        
        for event in try! context.fetch(Event.request()) {
            
            event.distance = current.distance(from: CLLocation(latitude: event.latitude, longitude: event.longitude))
            
        }
        
        try! context.save()
        
        self.update()
        
    }
    
}
