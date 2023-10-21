//
//  PlantService.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 10/10/23.
//

import Foundation
import UserNotifications
import CoreData

protocol PlantServiceProtocol {
    func addPlant(using parts: PlantParts) throws
    
    func updatePlant(_ plant: Plant, using parts: PlantParts, oldNextWateringDate: Date?) throws
    
    func deletePlant(_ plant: Plant) throws
    
    func deleteAllPlants() throws
    
    static func scheduleWaterReminderNotification() async
}

class PlantService: PlantServiceProtocol {
    static let notificationCategoryId = "WaterPlantNotification"
    var context = PersistenceController.shared.container.viewContext
    
    func addPlant(using parts: PlantParts) throws {
        // 1. Create a new instance of your Core Data entity.
        let plant = Plant(context: context)
        try updatePlant(plant, using: parts)
    }
    
    func updatePlant(_ plant: Plant, using parts: PlantParts, oldNextWateringDate: Date? = nil) throws {
        let newNextWateringDate = Calendar.current.date(byAdding: parts.interval.calendarUnit, value: Int(parts.unit), to: parts.lastWateredDate) ?? Date()

        // 2. Set the properties of the managed object as needed.
        plant.name = parts.name
        plant.location = parts.location
        plant.nextWateringDate = newNextWateringDate
        plant.interval = parts.interval
        plant.unit = Int32(parts.unit)
        
        // Save the image data to the file path
        switch parts.imageState {
        case .success(let data):
            // Create the url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appending(path: "\(UUID().uuidString).jpg")
            try? data.write(to: fileURL)

            plant.imageFilePath = fileURL.path
        default:
            break
        }
        
        // Update calendar decorations
        if let oldNextWateringDate {
            CalendarModel.shared.datesModified.insert(Calendar.current.dateComponents([.year, .month, .day], from: oldNextWateringDate))
        }
        
        CalendarModel.shared.datesModified.insert(Calendar.current.dateComponents([.year, .month, .day], from: newNextWateringDate))

        // 3. Save the managed object context to persist the new object to the Core Data store.
        try context.save()
    }
    
    func deletePlant(_ plant: Plant) throws {
        CalendarModel.shared.datesModified.insert(Calendar.current.dateComponents([.year, .month, .day], from: plant.nextWateringDate))

        context.delete(plant)

        try context.save()
    }
    
    func deleteAllPlants() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Plant")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
        try context.save()
    }
    
    // MARK: Local Notification methods
    
    static func scheduleWaterReminderNotification() async {
        // Check if app has permission to schedule notifications, may ask user for permission
        guard await authorizeIfNeeded() else { return }

        let context = PersistenceController.shared.container.viewContext
        
        // Clear pending notifications
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        // Fetch all plants
        let plants: [Plant] = (try? context.fetch(Plant.fetchRequest())) ?? []
        
        // Group plants by their nextWateringDate
        let groupedPlants = Dictionary(grouping: plants) { $0.nextWateringDate }
        
        // Iterate through grouped plants and create notification requests
        for (nextWateringDate, plants) in groupedPlants {
            let content = UNMutableNotificationContent()
            content.title = "Water Reminder"
            content.body = "You have \(plants.count) plants ready to be watered."
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = PlantService.notificationCategoryId
            
            // Create notification trigger
            var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nextWateringDate)
            if let notificationTime = UserDefaults.standard.string(forKey: "notificationTime") {
                let triggerTime = Date(timeIntervalSinceReferenceDate: Double(notificationTime) ?? 0.0)
                let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerTime)
                // Add user's prefered notification time
                triggerDateComponents.hour = timeComponents.hour
                triggerDateComponents.minute = timeComponents.minute
            } else {
                // Default notification time (12pm, noon)
                triggerDateComponents.hour = 12 // 24 hour clock
                triggerDateComponents.minute = 0
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Schedule the request
            try? await notificationCenter.add(request)
        }
    }
    
    static func removeAllWaterReminderNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private static func authorizeIfNeeded() async -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        let settings = await notificationCenter.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized:
            return true
        case .notDetermined:
            // Ask user for permission
            if let permissionGranted = try? await notificationCenter.requestAuthorization(options: [.alert, .sound]) {
                return permissionGranted
            } else {
                // Something went wrong
                return false
            }
        case .denied, .provisional, .ephemeral:
            return false
        @unknown default:
            return false
        }
    }
}
