//
//  ParkRunApp.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 2/4/2022.
//

import SwiftUI

@main
struct ParkRunApp: App {

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
             
        })

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
}
