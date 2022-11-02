//
//  EventView.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 2/5/2022.
//

import SwiftUI

struct EventView: View {
    
    @EnvironmentObject var location: LocationController
    
    @State var search: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            EventListElement(search: search, location_enabled: location.enabled)
            
        })
        .searchable(text: $search)
        
    }
    
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
