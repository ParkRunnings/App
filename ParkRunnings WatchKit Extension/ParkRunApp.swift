//
//  ParkRunApp.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 2/4/2022.
//

import SwiftUI
import UIKit

@main
struct ParkRunApp: App {
    
    @Environment(\.scenePhase) var phase
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup(content: {
          
            NavigationView(content: {
                MainView()
            })
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
            .environmentObject(MetaController.shared)
            .environmentObject(LocationController.shared)
            .environmentObject(EventController.shared)
            .environmentObject(RunnerController.shared)
            .environmentObject(SyncController.shared)
            .environmentObject(DesignController.shared)
            .onChange(of: phase, perform: { new in
                
                switch new {
                    
                    case .active:
                    SyncController.shared.start()
                    SyncController.shared.fire(source: .foreground)
                    
                    case .background:
                    SyncController.shared.fire(source: .background)
                    SyncController.shared.end()
                    
                    default: break
                    
                }

            })
             
        })

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
}
