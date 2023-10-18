//
//  Persistence.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let names = ["Lily", "Rose", "Tullip", "Sunflower", "Cactus", "Orhcid"]
        let location = ["Frontyard", "Bedroom", "Bedroom"]
        for i in 0..<names.count {
            let newPlant = Plant(context: viewContext)
            newPlant.name = names[i]
            newPlant.location = location[i % location.count]
            newPlant.nextWateringDate = Date.distantPast
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "FloraMinder")
        
        // Note: Database will reset so best to always start with this instead of migrating.
        // If you need to move a Core Data store to the container use the migratePersistentStore method
        // https://useyourloaf.com/blog/sharing-data-with-a-widget/
//        let url = URL.storeURL(for: "group.com.example.FloraMinder", databaseName: "FloraMinder")
//        let storeDescription = NSPersistentStoreDescription(url: url)
//        container.persistentStoreDescriptions = [storeDescription]
//
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.example.FloraMinder")!
        let storeURL = containerURL.appendingPathComponent("FloraMinder.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)

        container.persistentStoreDescriptions = [description]
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
