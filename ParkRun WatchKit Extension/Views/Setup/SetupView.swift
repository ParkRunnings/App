//
//  SetupView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import SwiftUI
import BarcodeKit
import CoreLocation

struct SetupView: View {
    
    @EnvironmentObject var location: LocationController
    @EnvironmentObject var meta: MetaController
    
    @State private var nav_barcode: Bool = false
    @State private var nav_event: Bool = false

    var body: some View {
        
        List(content: {
            
            TitleElement(
                title: "Setup",
                subtitle: "Preflight checklist"
            )
            
            SetupDetailsElement(
                step: .barcode,
                header: "Barcode",
                details: "Add your runner barcode to the app",
                complete: $meta.setup_barcode
            )
            
            if !meta.setup_barcode {
                
                ButtonNavigation(active: $nav_barcode, button: {
                    CardMedium(title: "Barcode Setup", symbol: "barcode", colour: Colour(hex: "#D1852B"))
                }, destination: { InputView() })
                    .simultaneousGesture(TapGesture().onEnded({ nav_barcode = true }))
                    .padding(.bottom, 20)
                
            }
            
            SetupDetailsElement(
                step: .location,
                header: "Location",
                details: "Grant location access to find nearby events",
                complete: $meta.setup_location
            )
            
            if !meta.setup_location {
                
                CardMedium(title: "Location Setup", symbol: "location.circle.fill", colour: Colour(hex: "#531459"))
                    .simultaneousGesture(TapGesture().onEnded({ location.authorise() }))
                    .padding(.bottom, 20)
                
            }
            
            SetupDetailsElement(
                step: .event,
                header: "Home",
                details: "Choose your home ParkRun event",
                complete: $meta.setup_home
            )
            
            if !meta.setup_home {
                
                ButtonNavigation(active: $nav_event, button: {
                    CardMedium(title: "Home Setup", symbol: "house.fill", colour: Colour(hex: "#2BD1A0"))
                }, destination: { HomeView() })
                    .simultaneousGesture(TapGesture().onEnded({ nav_event = true }))
                    .padding(.bottom, 20)
                
            }
            
            if meta.setup_barcode && meta.setup_location && meta.setup_home {
                CardShort(title: "Complete", symbol: "arrowtriangle.right.circle.fill", colour: Colour(hex: "#31D78B"))
                    .simultaneousGesture(TapGesture().onEnded({ meta.complete_setup() }))
                    .padding(.bottom, -20)
            }
            
            ListOverscroll()
            
        })
        .listStyle(.carousel)
        .onAppear(perform: {
            nav_barcode = false
            nav_event = false
        })
        .onLoad(perform: {
//            location.scrape_locations()
//            location.request()
//            Event.scrape(context: context)
        })
          
    }
    
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
