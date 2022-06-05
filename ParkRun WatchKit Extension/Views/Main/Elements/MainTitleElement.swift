//
//  MainTitleElement.swift
//  ParkRun
//
//  Created by Charlie on 3/4/2022.
//

import SwiftUI

struct MainTitleElement: View {
    
    @EnvironmentObject var location: LocationController
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            Text(location.closest?.name ?? "Unknown")
                .font(Font.system(size: 31, weight: .heavy, design: .default))
            MainLocationElement()
                .padding(.bottom, 20)
        })
        .listRowPlatterColor(.clear)
        
    }
    
}

struct MainTitleElement_Previews: PreviewProvider {
    static var previews: some View {
        MainTitleElement()
    }
}
