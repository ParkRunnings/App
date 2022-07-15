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
    
    private var event: Event?
    private var course: Course?
    
    @Published var uuid: UUID!
    @Published var name: String!
    @Published var distance: Double!
    @Published var start: String!
    
    @Published var time_progress: Double!
    @Published var distance_progress: Double!
    @Published var distance_display: String!
    
    @Published var image: Bool!
    @Published var coordinates: (Double, Double)?
    
    private var previous: CLLocation?
    
    override init() {
        super.init()
        
        event = fetch()
        course = fetch()
        refresh()
        
        if MetaController.shared.event_master == nil {
            
            let context = DataController.shared.container.viewContext
            
            let json = try! Data(contentsOf: Bundle.main.url(forResource: "master", withExtension: "json")!)

            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            decoder.dateDecodingStrategy = .iso8601
            
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
    
    func fetch() -> Course? {
        
        let context = DataController.shared.container.viewContext
        
        guard let event = event else { return nil }
        
        let request = Course.request()
        request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [event.uuid])
        
        let course = try? context.fetch(request).first
        
        return course
        
    }
    
    func update(event event_: Event) {
        
        event = event_
        DataController.shared.save()
        course = fetch()
        
        refresh()
        sync()
        
    }
    
    func update(course: Course) {
        
        self.course = course
        DataController.shared.save()
        
        refresh()
        
    }
    
    func update(new: CLLocation) {
        
        let request = Event.request()
        
        // If the new location is not significantly displaced from the previous location, only update the home event
        if previous?.distance(from: new) ?? Double.infinity < 500 {
            request.predicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid!])
        } else {
            previous = new
        }
        
        let context = DataController.shared.container.viewContext
            
        for event in try! context.fetch(request) {
            event.distance = new.distance(from: CLLocation(latitude: event.latitude, longitude: event.longitude))
        }
            
        try! context.save()
            
        refresh()
        
    }
    
    func scrape() async -> Course? {
       
        guard let event = event else { fatalError() }

        var request = URLRequest(url: URL(string: "https://storage.googleapis.com/parkrun-au/maps/\(event.uuid.description.lowercased()).json")!)

        return try? await DataController.shared.json(request: &request, as: Course.self)
        
    }
    
    func sync() {
        
        if event != nil && course == nil {
            
            Task(operation: {
                
                if let course = await scrape() {
                    DispatchQueue.main.async(execute: { [weak self] in
                        guard let self = self else { return }
                        self.update(course: course)
                    })
                }
                
            })
            
        }
        
    }
    
    func register_sync() {
        
        SyncController.shared.add(
            id: "event-scrape",
            method: sync,
            sources: [.register, .foreground],
            schedule: SyncSchedule(base: 300)
        )
        
    }
    
    func refresh() {
        
        uuid = event?.uuid ?? UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        name = event?.name ?? "-"
        distance = event?.distance ?? 0
        start = event?.start ?? "?"
        
        time_progress = event?.time_progress() ?? 0.0
        distance_progress = event?.distance_progress() ?? 0.0
        distance_display = event?.distance_display() ?? "?"
        
        image = course?.image ?? false
        
        if let latitude = event?.latitude, let longitude = event?.longitude {
            coordinates = (latitude, longitude)
        } else {
            coordinates = nil
        }
        
    }
    
    
    
//    func scrape_master() {
//
//        // To-Do: Add scenario handling for no-network events to ensure that location updates start getting called
//
//        var request = URLRequest(url: URL(string: "https://storage.googleapis.com/parkrun-au/master.json")!)
//
//        let data = try! await DataController.shared.json(request: &request, as: EventMeta.self)
//
//        print("Downloaded \(data.events.count) location points")
//        print("Refreshed \(data.refreshed)")
//
//        try! context.save()
//
//        LocationController.shared.start()
//
//    }
    
}
