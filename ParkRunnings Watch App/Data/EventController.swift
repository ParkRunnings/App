//
//  LocationController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 10/4/2022.
//

import Foundation
import CoreData
import CoreLocation

class EventController: NSObject, ObservableObject {

    static let shared = EventController()
    
    private var event: Event?
    private var course: Course?
    
    private var target = "master" // "tests/master_e"
    
    @Published var uuid: UUID!
    @Published var name: String!
    @Published var distance: Double!
    
    @Published var time_display: String!
    @Published var time_progress: Double!
    @Published var distance_display: String!
    @Published var distance_progress: Double!
    
    @Published var image: Bool!
    @Published var coordinates: (Double, Double)?
    
    override init() {
        super.init()
        
        event = fetch()
        course = fetch()
        refresh()
        
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
    
    func fetch() -> Course? {
        
        let context = DataController.shared.container.viewContext
        
        guard let event = event else { return nil }
        
        let request = Course.request()
        request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [event.uuid])
        
        if let course = try? context.fetch(request).first {
            return course
        } else {
            
            Task(operation: {
                guard let course = await scrape_course() else { return }
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let self = self else { return }
                    self.update(course: course)
                })
            })
            
            return nil
            
        }
        
    }
    
    func update(event: Event) {
        
        self.event = event
        DataController.shared.save()
        course = fetch()
        
        refresh()
        
    }
    
    func update(course: Course) {
        
        self.course = course
        DataController.shared.save()
        
        refresh()
        
    }
    
    func update(new: CLLocation) {
        
        let request = Event.request()
        let context = DataController.shared.container.viewContext
            
        for event in try! context.fetch(request) {
            event.distance = new.distance(from: CLLocation(latitude: event.latitude, longitude: event.longitude))
        }
            
        try! context.save()
            
        refresh()
        
    }
    
    func clear() {
        
        let request = Event.request()
        let context = DataController.shared.container.viewContext
            
        for event in try! context.fetch(request) {
            event.distance = -1
        }
            
        try! context.save()
            
        refresh()
        
    }
    
    // Scraping methods
    
    func scrape_course() async -> Course? {
        
        guard let event = event, let course = try? await DataController.shared.json(
            url: "https://storage.googleapis.com/parkrun-au/maps/\(event.uuid.string()).json",
            as: Course.self
        ) else { return nil }
        
        DataController.shared.save()
        
        return course
        
    }
    
    func scrape_master() async -> EventMeta? {
        
        // Scrape the event master data
        guard let master = try? await DataController.shared.json(
            url: "https://storage.googleapis.com/parkrun-au/\(self.target).json",
            as: EventMeta.self
        ) else { return nil }
        
        let request = Event.request()
        let context = DataController.shared.container.viewContext
        
        // Current event UUIDs for fast lookup
        let lookup = Set(master.events.map({ $0.uuid }))
        
        DispatchQueue.main.async(execute: {
            
            // Refresh the new master event state
            MetaController.shared.event_master = master.state
            
            // Check if the users home event has been deleted from the remote server
            if let event_home = MetaController.shared.event_home, !lookup.contains(event_home) {
                print("Home event has been deleted from remote server")
                MetaController.shared.event_home = nil
                EventController.shared.event = nil
            }
            
            DataController.shared.save()
            
            if let current = LocationController.shared.current {
                EventController.shared.update(new: current)
            }
            
            DataController.shared.save()
            MetaController.shared.refresh()
            
            if let existing = try? context.fetch(request) {
                
                for index in 0 ..< existing.count {
                    
                    let event = existing[index]
                    
                    // Check if the lookup does not contains the existing uuid, meaning it has been removed from the remote server
                    if !lookup.contains(event.uuid) {
                        context.delete(event)
                    }
                    
                }
                
                DataController.shared.save()
                
            }
            
        })
        
        return master
        
    }
    
    func scrape_master_state() async -> MasterState? {
        
        guard let master_state = try? await DataController.shared.json(
            url: "https://storage.googleapis.com/parkrun-au/state/\(self.target).json",
            as: MasterState.self
        ) else { return nil }
        
        return master_state
        
    }
    
    func scrape_event_state() async -> EventState? {
        
        guard let event = event, let event_state = try? await DataController.shared.json(
            url: "https://storage.googleapis.com/parkrun-au/state/\(event.uuid.string()).json",
            as: EventState.self
        ) else { return nil }
        
        return event_state
        
    }
    
    func sync() {
        
        if MetaController.shared.event_master == nil {
            
            let context = DataController.shared.container.viewContext
            
            let json = try! Data(contentsOf: Bundle.main.url(forResource: "master", withExtension: "json")!)

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try! decoder.decode(EventMeta.self, from: json)
            MetaController.shared.event_master = data.state
            
            DataController.shared.save()
            
            if let current = LocationController.shared.current {
                EventController.shared.update(new: current)
            }
            
            print("Loaded master data from local")
            
        }
        
        Task(operation: {
            
            var state_change: Bool = false
            
            if let master_state = await scrape_master_state(), master_state.state != MetaController.shared.event_master  {
                
                print("Master data is out of date, starting refresh")
                _ = await scrape_master()
                state_change = true
                print("Finished master data refresh")
                
            }
            
            if let event_state = await scrape_event_state(), event_state.course != course?.state {
                
                print("Course data is out of date, starting refresh")
                course = await scrape_course()
                state_change = true
                print("Finished course data refresh")
                
            }
            
            if state_change {
                
                DispatchQueue.main.async(execute: { [weak self] in
                    
                    guard let self = self else { return }
                    
                    if let event: Event = self.fetch() {
                        self.update(event: event)
                    }
                    
                })
                
            }
            
        })
    }
    
    func register_sync() {
        
        SyncController.shared.add(
            id: "event-sync",
            method: sync,
            sources: [.register, .foreground],
            schedule: SyncSchedule(base: MetaController.simulator ? 10 : 1800)
        )
        
    }
    
    func refresh() {
        
        uuid = event?.uuid ?? UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        name = event?.name ?? "-"
        distance = event?.distance ?? 0
        
        time_display = event?.time_display() ?? ""
        time_progress = event?.time_progress() ?? 0.0
        distance_display = event?.distance_display() ?? "?"
        distance_progress = event?.distance_progress() ?? 0.0
        
        image = course?.image ?? false
        
        if let latitude = event?.latitude, let longitude = event?.longitude {
            coordinates = (latitude, longitude)
        } else {
            coordinates = nil
        }
        
    }
    
}
