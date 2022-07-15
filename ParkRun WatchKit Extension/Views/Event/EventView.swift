//
//  EventView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 2/5/2022.
//

import SwiftUI

struct EventView: View {
    
    @State var search: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            EventListElement(search: search)
            
        })
        .searchable(text: $search)
        
    }
    
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
