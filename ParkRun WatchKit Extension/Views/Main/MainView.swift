//
//  MainView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 2/4/2022.
//

import SwiftUI
import BarcodeKit
import CoreLocation

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var location: LocationController
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var runner: RunnerController
    @EnvironmentObject var event: EventController
    @EnvironmentObject var design: DesignController
    
    @State private var nav_barcode: Bool = false
    @State private var nav_event: Bool = false
    @State private var nav_map: Bool = false
    
    
    var body: some View {
        
        List(content: {
            
            VStack(alignment: .leading, content: {
                
                TitleTextElement(text: event.name)
                
                HStack(alignment: .center, spacing: design.size(size: .progress_item_spacing), content: {
                    
                    MainTimeProgress(progress: $event.time_progress, start: $event.start)
                    
                    MainDistanceProgress(progress: $event.distance_progress, distance: $event.distance_display)
                        .hidden(!location.enabled)
                    
                    Spacer()
                    
                    ButtonNavigation(active: $nav_event, button: {
                        CardMicro(symbol: "pencil.circle.fill")
                    }, destination: { EventView() })
                        .simultaneousGesture(TapGesture().onEnded({ nav_event = true }))
                    
                })
                
    //            MarqueeText(text: "Pay money wubby is a bad boy", font: UIFont.boldSystemFont(ofSize: 31), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
              
            })
            .listRowPlatterColor(.clear)
            .padding(.bottom, 10)
            
            ButtonNavigation(active: $nav_barcode, button: {
                CardTall(title: "View Barcode", symbol: "barcode.viewfinder", colour: Colour(hex: "#556FB0"))
            }, destination: { BarcodeView() })
                .simultaneousGesture(TapGesture().onEnded({ nav_barcode = true }))
                .padding(.bottom, 4)
            
            if event.image {
                
                ButtonNavigation(active: $nav_map, button: {
                    CardTall(title: "View Course", symbol: "map.fill", colour: Colour(hex: "#B64EC2"))
                }, destination: { MapView(uuid: event.uuid) })
                    .simultaneousGesture(TapGesture().onEnded({ nav_map = true }))
                    .padding(.bottom, 4)
                
            }
            
            if let coordinates = event.coordinates {
                
                CardTall(title: "Get Directions", symbol: "location.fill", colour: Colour(hex: "#6BB866"))
                    .simultaneousGesture(TapGesture().onEnded({
                        openURL(URL(string: "http://maps.apple.com/?q=\(coordinates.0),\(coordinates.1)&ll=\(coordinates.0),\(coordinates.1)&z=15")!)
                    }))
                    .padding(.bottom, 4)
                
            }
            
            CardTall(title: "Reset App", symbol: "trash.fill", colour: Colour(hex: "#949494"))
                .simultaneousGesture(TapGesture().onEnded({ meta.reset() }))
                .padding(.bottom, 4)
            
            ListOverscroll()
            
        })
        .listStyle(.carousel)
        .sheet(isPresented: !$meta.setup, content: {
            WelcomeView()
                .interactiveDismissDisabled()
                .toolbar(content: {
                    ToolbarItem(id: "x", placement: .cancellationAction, showsByDefault: false, content: {
                        Text("")
                    })
                })
        })
        .onLoad(perform: {
            location.register_sync()
            event.register_sync()
        })
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
