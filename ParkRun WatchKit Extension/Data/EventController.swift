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

    func update_distance(current: CLLocation) {
        
        let context = DataController.shared.container.viewContext
        
        for event in try! context.fetch(Event.request()) {
            
            event.distance = current.distance(from: CLLocation(latitude: event.latitude, longitude: event.longitude))
            
        }
        
        try! context.save()
        
    }

}
