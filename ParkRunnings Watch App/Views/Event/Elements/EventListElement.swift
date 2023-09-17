//
//  EventListElement.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 5/5/2022.
//

import SwiftUI
import UIKit
import WatchKit

struct EventListElement: View {
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var event: EventController
    @EnvironmentObject var location: LocationController
    
    @Environment(\.presentationMode) var presentation
    @Environment(\.openURL) private var openURL
    
    @FetchRequest var events: FetchedResults<Event>
    
    @State private var nav_permissions: Bool = false

    init(search: String, location_enabled: Bool) {
        
        _events = FetchRequest<Event>(
            sortDescriptors: location_enabled ? [NSSortDescriptor(key: "distance", ascending: true)] : [NSSortDescriptor(key: "name", ascending: true)],
            predicate: search.isEmpty ? nil : NSPredicate(format: "name CONTAINS %@", search),
            animation: .default
        )
        
    }
    
    var body: some View {
        
        List(content: {
            
            if location.enabled {
                TitleElement(title: "Events", subtitle: nil)
            } else {
                
                let event_title = TitleElement(title: "Events", subtitle: "👉 Tap to enable location services for event sorting")
                
                if location.status == .notDetermined {
                    event_title
                        .simultaneousGesture(TapGesture().onEnded({ location.authorise() }))
                } else {
                    ButtonNavigation(active: $nav_permissions, button: {
                        event_title
                    }, destination: { PermissionView() })
                        .simultaneousGesture(TapGesture().onEnded({ nav_permissions = true }))
                }
              
            }
            
            ForEach(events, content: { each in
                EventLocationElement(name: each.name, country: each.country, meters: location.enabled ? Int(each.distance) : -1)
                    .simultaneousGesture(TapGesture().onEnded({
                        meta.update_home(event: each)
                        presentation.wrappedValue.dismiss()
                    }))
            })
            
        })
        .listStyle(.carousel)
        
    }
    
}
