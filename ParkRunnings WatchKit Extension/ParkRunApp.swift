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
                    print("Active")
                    SyncController.shared.start()
                    SyncController.shared.fire(source: .foreground)
                    
                    case .background:
                    print("Background")
                    
                    case .inactive:
                    print("Inactive")
                    SyncController.shared.fire(source: .background)
                    SyncController.shared.end()
                    
                    default: print("Hi")
                    
                }

            })
             
        })

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
}
