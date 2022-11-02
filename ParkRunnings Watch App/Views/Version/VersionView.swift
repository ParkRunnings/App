//
//  PermissionView.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 2/11/2022.
//

import Foundation
import SwiftUI

struct VersionView: View {
    
    @EnvironmentObject var meta: MetaController
    
    static let version: String = "1.1"
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            
            List(content: {
                
                TitleTextElement(text: "Update v\(VersionView.version)")
                    .padding(.bottom, -16)
                
                SubheadingTextElement(text: "Thank you for using ParkRunnings!")
                
                Image("stats")
                    .resizable()
                    .scaledToFit()
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(.top, 10)
                
                SubheadingTextElement(text: "A new statistics area has been added, bringing key run metrics to your watch along with recent performance charts (WatchOS 9 only).")
                
                Image("chart")
                    .resizable()
                    .scaledToFit()
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(.top, 10)
                
                SubheadingTextElement(text: "There is also a new results area where you can view your full ParkRun history.")
                    .padding(.top, 40)
                
                Image("results")
                    .resizable()
                    .scaledToFit()
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                SubheadingTextElement(text: "See you out on the next ParkRun!")
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                CardShort(title: "Continue", symbol: "arrowtriangle.right.circle.fill", colour: Colour(hex: "#31D78B"))
                    .simultaneousGesture(TapGesture().onEnded({ meta.acknowledge_version() }))
                    .padding(.bottom, -20)
                
            })
            .listStyle(.plain)
            
        })
        
    }
    
}
