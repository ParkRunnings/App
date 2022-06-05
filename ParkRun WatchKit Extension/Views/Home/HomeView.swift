//
//  HomeView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 2/5/2022.
//

import SwiftUI

struct HomeView: View {
    
    @State var search: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            HomeListElement(search: search)
            
        })
        .searchable(text: $search)
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(search: "Poopybutthole")
    }
}
