//
//  MasterController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 28/4/2022.
//

import CoreData
import CoreLocation

class LocationController: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationController()
    private let manager: CLLocationManager
    private var polling: Bool = false
    
    @Published var enabled: Bool
    @Published var status: CLAuthorizationStatus
    @Published var location: CLLocation?
    @Published var closest: Event?
    
    override init() {
        
        manager = CLLocationManager()
        status = manager.authorizationStatus
        enabled = LocationController.check_enabled(status: manager.authorizationStatus)
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
    static func check_enabled(status: CLAuthorizationStatus) -> Bool {
        
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
            return true
            
            case .notDetermined, .restricted, .denied:
            return false
            
            @unknown default:
            fatalError()
        }
        
    }
    
    func authorise() {
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func start() {
        
        if enabled && !polling {
            manager.startUpdatingLocation()
            polling = true
        } else if enabled && polling {
            print("Already polling")
        }
        
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        status = manager.authorizationStatus
        enabled = LocationController.check_enabled(status: manager.authorizationStatus)
        MetaController.shared.setup_location = status != .notDetermined
        
        start()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // To-Do: Improve the battry usage of these updates via disabling, limiting, significant locations etc
        
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        
        let current = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        EventController.shared.update_distance(current: current)
        self.location = current
        
        stop()
        
    }
    
    
    func scrape_locations() {
        
        // To-Do: Add scenario handling for no-network events to ensure that location updates start getting called

        let url = URL(string: "https://storage.googleapis.com/parkrun-au/master.json")!
        
        let context = DataController.shared.container.viewContext
        
        Task(operation: {
            
            let (json, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            
            let data = try decoder.decode(EventMeta.self, from: json)
            
            print("Downloaded \(data.events.count) location points")
            print("Refreshed \(data.refreshed)")
            
            try! context.save()
            
            start()
            
        })
        
    }
    
    func scrape_event(uuid: UUID) {
        
        let url = URL(string: "https://storage.googleapis.com/parkrun-au/events/\(uuid.description.lowercased()).json")!
        
        let context = DataController.shared.container.viewContext
        
        Task(operation: {
            
            let (json, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            
            let event = try decoder.decode(Event.self, from: json)
            
            print("Downloaded for uuid: \(uuid) \(event)")
            
            try! context.save()
            
            DispatchQueue.main.async{
                self.closest = event
            }
            
        })
        
    }
    
    /**
     A method for finding the nearby ParkRun events to a user
     
     - Parameters:
        - latitude: The users latitude in decimal format
        - longitude: The users longitude in decimal format
        - radius: The number of meters around the user to search for events
     
     - Returns: An array of nearby events or   `nil` if no events were located
     */
    
    func nearby(latitude: Double, longitude: Double, radius: LocationRadius) -> Array<Event> {
        
        let context = DataController.shared.container.viewContext
            
        let earth: Double = 6378137
        
        let delta_latitude = radius.rawValue / earth * 180.0 / Double.pi
        let delta_longitude = radius.rawValue / (earth * cos(latitude * Double.pi / 180.0)) * 180.0 / Double.pi
            
        let min_latitude = latitude - delta_latitude
        let max_latitude = latitude + delta_latitude
        let min_longitude = longitude - delta_longitude
        let max_longitude = longitude + delta_longitude
            
        let request = Event.request()
        
        request.predicate = NSPredicate(
            format: "(latitude >= %@ AND latitude <= %@) AND (longitude >= %@ AND longitude <= %@)",
            argumentArray: [min_latitude, max_latitude, min_longitude, max_longitude]
        )
        
        return try! context.fetch(request)
        
    }
//
//    func refresh() {
//
//        guard let location = location else { return }
//
//        let locations = nearby(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, radius: LocationRadius.km_5)
//
//        let test = locations.map({ ($0, location.distance(from: $0.coordinates())  ) }).sorted(by: { $0.1 < $1.1 })
//
//        guard let first = test.first?.0 else { return }
//
//        scrape_event(uuid: first.uuid)
//
//    }
//
    
        
    
    
    
}
