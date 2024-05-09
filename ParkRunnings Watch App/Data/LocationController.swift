//
//  MasterController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 28/4/2022.
//

import CoreData
import CoreLocation

class LocationController: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationController()
    private let manager: CLLocationManager = CLLocationManager()
    private var polling: Bool = false
    
    @Published var enabled: Bool
    @Published var status: CLAuthorizationStatus
    @Published var current: CLLocation?
    
    override init() {
        
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
        
        MetaController.shared.update_location_requested()
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func start() {
        
        status = manager.authorizationStatus
        enabled = LocationController.check_enabled(status: manager.authorizationStatus)
        
        if enabled && !polling {
            manager.startUpdatingLocation()
            polling = true
        } else if enabled && polling {
            print("Already polling")
        }
        
    }
    
    func stop() {
        manager.stopUpdatingLocation()
        polling = false
    }
    
    func register_sync() {
        
        if enabled {
            SyncController.shared.add(
                id: "location-update",
                method: start,
                sources: [.register, .timer, .foreground],
                schedule: SyncSchedule(base: 60, sat: 30)
            )
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        status = manager.authorizationStatus
        
        enabled = LocationController.check_enabled(status: manager.authorizationStatus)
        
        MetaController.shared.setup_location = MetaController.shared.location_requested || status != .notDetermined
        
        if !enabled && !MetaController.simulator {
            EventController.shared.clear()
        }
        
        register_sync()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else { return }
        
        let new = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        print("Current location: \(new)")
        
        EventController.shared.update_location(new: new)
        current = new
        
        stop()
        
    }
    
}
