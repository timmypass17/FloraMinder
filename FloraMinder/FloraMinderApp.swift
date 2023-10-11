//
//  FloraMinderApp.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//

import SwiftUI
import WidgetKit

@main
struct FloraMinderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem { Label("Garden", systemImage: "leaf.fill") }

                ScheduleView()
                    .tabItem { Label("Calendar", systemImage: "calendar") }
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }

            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .background:
                    Task {
                        await PlantService.scheduleWaterReminderNotification()
                    }
                    
                    WidgetCenter.shared.reloadTimelines(ofKind: "FloraMinderWidget")
                @unknown default:
                    break
                }
            }
        }
    }
}
