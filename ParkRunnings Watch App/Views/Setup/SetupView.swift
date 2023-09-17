//
//  SetupView.swift
//  ParkRunnings WatchKit Extension
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
        
        ScrollViewReader(content: { reader in
            
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
                .id(SetupCardType.barcode)
                
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
                    details: "Location access to find nearby events",
                    complete: $meta.setup_location
                )
                .id(SetupCardType.location)
                
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
                .id(SetupCardType.event)
                
                if !meta.setup_home {
                    
                    ButtonNavigation(active: $nav_event, button: {
                        CardMedium(title: "Home Setup", symbol: "house.fill", colour: Colour(hex: "#2BD1A0"))
                    }, destination: { EventView() })
                        .simultaneousGesture(TapGesture().onEnded({ nav_event = true }))
                        .padding(.bottom, 20)
                    
                }
                
                if meta.setup_complete {
                    CardShort(title: "Complete", symbol: "arrowtriangle.right.circle.fill", colour: Colour(hex: "#31D78B"))
                        .simultaneousGesture(TapGesture().onEnded({ meta.complete_setup() }))
                        .padding(.bottom, -20)
                        .id(SetupCardType.complete)
                }
                
                ListOverscroll()
                
            })
            .listStyle(.carousel)
            .onAppear(perform: {
                
//                nav_barcode = false
//                nav_event = false
                
                if !meta.setup_barcode {
                    reader.scrollTo(SetupCardType.barcode)
                } else if !meta.setup_location {
                    reader.scrollTo(SetupCardType.location)
                } else if !meta.setup_home {
                    reader.scrollTo(SetupCardType.event)
                } else {
                    reader.scrollTo(SetupCardType.complete)
                }
                
            })
            
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
