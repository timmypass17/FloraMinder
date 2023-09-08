//
//  FloraMinderApp.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//

import SwiftUI

@main
struct FloraMinderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Garden", systemImage: "leaf.fill")
                    }
                
//                Text("Schedule") // today, tomarrow... and show past watering history?
//                Text("Hello World")
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .background:
                    Task {
                        await Plant.scheduleWaterReminderNotification()
                    }
                @unknown default:
                    break
                }
            }
        }
    }
}
