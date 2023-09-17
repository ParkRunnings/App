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
    
    
    // New methods
    
    override init() {
        super.init()
        
        event = fetch_event()
        course = fetch_course(uuid: event?.uuid)
        
        refresh()
        
    }
    
    
    // Core Data Fetch Methods
    
    func fetch_event() -> Event? {

        let context = DataController.shared.container.viewContext

        guard let home = MetaController.shared.event_home else { return nil }

        let request = Event.request()
        request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [home])

        guard let event = try! context.fetch(request).first else {
            MetaController.shared.event_home = nil
            DataController.shared.save(context: context)
            return nil
        }

        return event

    }
    
    func fetch_course(uuid: UUID?) -> Course? {
        
        guard let uuid else { return nil }
        
        let context = DataController.shared.container.viewContext
        
        let request = Course.request()
        request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid])
        
        guard let course = try? context.fetch(request).first else { return nil }
        
        return course
        
    }
    
    
    
    // HTTP Scrape Methods
    
    func scrape_course(uuid: UUID) {
        
        Task(operation: {
            
            let _ = try? await DataController.shared.json(
                url: URL(string: "https://storage.googleapis.com/parkrun-au/maps/\(uuid.string()).json")!,
                as: Course.self
            )
            
            DispatchQueue.main.async(execute: { [weak self] in
                guard let self else { return }
                self.course = fetch_course(uuid: uuid)
                self.refresh()
            })
            
        })
        
    }
    
    func scrape_master() {
        
        Task(operation: {
            
            guard let master = try? await DataController.shared.json(
                url: URL(string: "https://storage.googleapis.com/parkrun-au/\(self.target).json")!,
                as: EventMeta.self
            ) else { return }
            
            // Current event UUIDs for fast lookup
            let lookup = Set(master.events.map({ $0.uuid }))
            
            DispatchQueue.main.async(execute: { [weak self] in
                
                if let self {
                    
                    let request = Event.request()
                    let context = DataController.shared.container.viewContext
                    
                    // Refresh the new master event state
                    MetaController.shared.event_master = master.state
                    
                    // Check if the users home event has been deleted from the remote server
                    if let event_home = MetaController.shared.event_home, !lookup.contains(event_home) {
                        print("Home event has been deleted from remote server")
                        MetaController.shared.event_home = nil
                        EventController.shared.event = nil
                    }
                    
                    DataController.shared.save(context: context)
                    
                    if let current = LocationController.shared.current {
                        EventController.shared.update_location(new: current)
                    }
                    
                    DataController.shared.save(context: context)
                    MetaController.shared.refresh()
                    
                    if let existing = try? context.fetch(request) {
                        
                        for index in 0 ..< existing.count {
                            
                            let event = existing[index]
                            
                            // Check if the lookup does not contains the existing uuid, meaning it has been removed from the remote server
                            if !lookup.contains(event.uuid) {
                                context.delete(event)
                            }
                            
                        }
                        
                        DataController.shared.save(context: context)
                        
                    }
                    
                    if let event = self.fetch_event() {
                        self.update_event(event: event)
                    }
                    
                }
                
            })
            
        })
        
    }

    func scrape_master_state() async -> MasterState? {
        
        guard let master_state = try? await DataController.shared.json(
            url: URL(string: "https://storage.googleapis.com/parkrun-au/state/\(self.target).json")!,
            as: MasterState.self
        ) else { return nil }
        
        return master_state
        
    }
    
    func scrape_event_state(uuid: UUID) async -> EventState? {
        
        guard let event_state = try? await DataController.shared.json(
            url: URL(string: "https://storage.googleapis.com/parkrun-au/state/\(uuid.string()).json")!,
            as: EventState.self
        ) else { return nil }
        
        return event_state
        
    }
    
      
    // Update Methods
    
    func update_location(new: CLLocation) {
        
        let request = Event.request()
        let context = DataController.shared.container.viewContext
            
        for event in try! context.fetch(request) {
            event.distance = new.distance(from: CLLocation(latitude: event.latitude, longitude: event.longitude))
        }
            
        DataController.shared.save(context: context)
            
        refresh()
        
    }
    
    func update_event(event: Event) {
        
        self.event = event
        
        if let course = fetch_course(uuid: event.uuid) {
            self.course = course
        } else {
            scrape_course(uuid: event.uuid)
        }
        
        refresh()
        
    }
    
    
    
    // Other Methods
    
    func clear() {
        
        let request = Event.request()
        let context = DataController.shared.container.viewContext
            
        for event in try! context.fetch(request) {
            event.distance = -1
        }
            
        DataController.shared.save(context: context)
            
        refresh()
        
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
            
            DataController.shared.save(context: context)
            
            if let current = LocationController.shared.current {
                EventController.shared.update_location(new: current)
            }
            
            print("Loaded master data from local")
            
        }
        
        // Retrieving the event uuid & course state outside the task context to prevent CoreData issue
        let event_uuid = event?.uuid
        let course_state = course?.state
        
        Task(operation: {
            
            if let master_state = await scrape_master_state(), master_state.state != MetaController.shared.event_master {
                print("Refreshing master")
                scrape_master()
            } else if let event_uuid, let event_state = await scrape_event_state(uuid: event_uuid), event_state.course != course_state {
                print("Refreshing course")
                scrape_course(uuid: event_uuid)
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
