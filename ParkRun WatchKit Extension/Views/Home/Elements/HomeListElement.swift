//
//  HomeListElement.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 5/5/2022.
//

import SwiftUI

struct HomeListElement: View {
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var location: LocationController
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest var events: FetchedResults<Event>

    init(search: String) {
        
        _events = FetchRequest<Event>(
            sortDescriptors: [NSSortDescriptor(key: "distance", ascending: true), NSSortDescriptor(key: "name", ascending: true)],
            predicate: search.isEmpty ? nil : NSPredicate(format: "name CONTAINS %@", search),
            animation: .default
        )
        
    }
    
    var body: some View {
        
        List(content: {
            
            TitleElement(title: "Events", subtitle: location.enabled ? nil : "Enable location services to find nearby events")
            
            ForEach(events, content: { event in
                HomeEventElement(name: event.name, country: event.country, meters: Int(event.distance))
                    .onTapGesture(perform: {
                        meta.update_home(event: event)
                        presentationMode.wrappedValue.dismiss()
                    })
            })
            
        })
        .listStyle(.carousel)
        
    }
    
}

struct HomeListElement_Previews: PreviewProvider {
    static var previews: some View {
        HomeListElement(search: "Shit")
    }
}

