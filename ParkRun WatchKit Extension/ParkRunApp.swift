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
        WindowGroup {
            NavigationView {
                MainView()
                    .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                    .environmentObject(MetaController.shared)
                    .environmentObject(LocationController.shared)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
}
