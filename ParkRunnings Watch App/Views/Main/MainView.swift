//
//  MainView.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 2/4/2022.
//

import SwiftUI
import BarcodeKit
import CoreLocation

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var location: LocationController
    @EnvironmentObject var runner: RunnerController
    @EnvironmentObject var event: EventController
    @EnvironmentObject var design: DesignController
    
    @State private var nav_barcode: Bool = false
    @State private var nav_event: Bool = false
    @State private var nav_map: Bool = false
    @State private var nav_stats: Bool = false
    @State private var nav_results: Bool = false
    @State private var nav_permissions: Bool = false
    @State private var nav_about: Bool = false
    
    var body: some View {
        
        ScrollViewReader(content: { reader in
            
            List(content: {
                
                VStack(alignment: .leading, content: {
                    
                    TitleTextElement(text: event.name)
                    
                    HStack(alignment: .center, spacing: design.size(size: .progress_item_spacing), content: {
                        
                        MainTimeProgress(progress: $event.time_progress, start: $event.time_display)
                        
                        if location.enabled {
                            MainDistanceProgress(progress: $event.distance_progress, distance: $event.distance_display)
                        } else {
                            
                            let options = ["🤷‍♀️", "🤷🏻‍♀️", "🤷🏼‍♀️", "🤷🏽‍♀️", "🤷🏾‍♀️", "🤷🏿‍♀️", "🤷‍♂️", "🤷🏻‍♂️", "🤷🏼‍♂️", "🤷🏽‍♂️", "🤷🏾‍♂️", "🤷🏿‍♂️"]
                            var seed = RandomNumberGeneratorWithSeed(seed: Int(Date().timeIntervalSince1970 / 86400))
                            
                            let progress = MainDistanceProgress(progress: .constant(0.0), distance: .constant(options[Int.random(in: 0 ..< options.count, using: &seed)]))
                            
                            if location.status == .notDetermined {
                                progress
                                    .simultaneousGesture(TapGesture().onEnded({ location.authorise() }))
                            } else {
                                ButtonNavigation(active: $nav_permissions, button: { progress }, destination: { PermissionView() })
                                    .simultaneousGesture(TapGesture().onEnded({ nav_permissions = true }))
                            }
                            
                        }
                        
                        Spacer()
                        
                        ButtonNavigation(active: $nav_event, button: {
                            CardMicro(symbol: "pencil.circle.fill")
                        }, destination: { EventView() })
                            .simultaneousGesture(TapGesture().onEnded({ nav_event = true }))
                        
                    })
                  
                })
                .listRowPlatterColor(.clear)
                .padding(.bottom, 10)
                .id("title")
                
                ButtonNavigation(active: $nav_barcode, button: {
                    CardTall(title: "View Barcode", symbol: "barcode.viewfinder", colour: Colour(hex: "#D03425"))
                }, destination: { BarcodeView() })
                    .simultaneousGesture(TapGesture().onEnded({ nav_barcode = true }))
                    .padding(.bottom, 4)
                
                ButtonNavigation(active: $nav_stats, button: {
                    CardTall(title: "Statistics", symbol: "chart.line.uptrend.xyaxis", colour: Colour(hex: "#3925C3"))
                }, destination: { StatsView() })
                    .simultaneousGesture(TapGesture().onEnded({ nav_stats = true }))
                    .padding(.bottom, 4)
                
                ButtonNavigation(active: $nav_results, button: {
                    CardTall(title: "Past Results", symbol: "timer", colour: Colour(hex: "#26A363"))
                }, destination: { ResultsView(results: ResultBreakdown(results: runner.results_sorted)) })
                    .simultaneousGesture(TapGesture().onEnded({ nav_results = true }))
                    .padding(.bottom, 4)
                
                if event.image {
                    
                    ButtonNavigation(active: $nav_map, button: {
                        CardTall(title: "View Course", symbol: "map.fill", colour: Colour(hex: "#E3951C"))
                    }, destination: { MapView(uuid: event.uuid) })
                        .simultaneousGesture(TapGesture().onEnded({ nav_map = true }))
                        .padding(.bottom, 4)
                    
                }
                
                if let coordinates = event.coordinates {
                    
                    CardTall(title: "Get Directions", symbol: "location.fill", colour: Colour(hex: "#981352"))
                        .simultaneousGesture(TapGesture().onEnded({
                            openURL(URL(string: "http://maps.apple.com/?q=\(coordinates.0),\(coordinates.1)&ll=\(coordinates.0),\(coordinates.1)&z=15")!)
                        }))
                        .padding(.bottom, 4)
                    
                }
                
                CardTall(title: "Reset App", symbol: "trash.fill", colour: Colour(hex: "#20222D"))
                    .simultaneousGesture(TapGesture().onEnded({
                        meta.reset()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            reader.scrollTo("title")
                        })
                        
                    }))
                    .padding(.bottom, 4)
                
                ButtonNavigation(active: $nav_about, button: {
                    CardTall(title: "About", symbol: "info.circle", colour: Colour(hex: "#7F7181"))
                }, destination: { AboutView() })
                    .simultaneousGesture(TapGesture().onEnded({ nav_about = true }))
                    .padding(.bottom, 4)
                
                ListOverscroll()
                
            })
            .listStyle(.carousel)
            
        })
        .sheet(isPresented: !$meta.nav_setup, content: {
            WelcomeView()
                .interactiveDismissDisabled()
                .toolbar(content: {
                    ToolbarItem(id: "x", placement: .cancellationAction, showsByDefault: false, content: {
                        Text("")
                    })
                })
        })
        .sheet(isPresented: $meta.nav_version, content: {
            VersionView()
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

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
