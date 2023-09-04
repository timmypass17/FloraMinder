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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
