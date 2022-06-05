//
//  GeneralElements.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI


struct ListOverscroll: View {
    
    var body: some View {
        Colour(hex: "#000000")
            .frame(width: 10, height: 30, alignment: .center)
            .listRowPlatterColor(.clear)
            .opacity(0.0)
    }
    
}


