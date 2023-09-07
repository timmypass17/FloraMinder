//
//  FloraMinderApp.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//

import SwiftUI

@main
struct FloraMinderApp: App {
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
        }
    }
}
