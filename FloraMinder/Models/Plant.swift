//
//  Plant.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//
//

import Foundation
import CoreData
import UserNotifications


@objc(Plant)
public class Plant: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var name_: String?
    @NSManaged public var location_: String?
    @NSManaged public var interval_: String?
    @NSManaged public var unit: Int32
    @NSManaged public var lastWatered_: Date?
    @NSManaged public var imageFilePath: String?
}

extension Plant : Identifiable { }

extension Plant {
    
    var nextWateringDate: Date {
        let nextWateringDate = Calendar.current.date(byAdding: interval.calendarUnit, value: Int(unit), to: lastWatered) ?? Date()
        // Set the time components to noon (12:00 PM) or users preference
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: nextWateringDate) ?? Date()
    }
    
    var daysUntilNextWatering: String {
        let secondsPerDay: TimeInterval = 86400
        // Convert the date to a timestamp (integer) in seconds
        let startTimestampInDays = Date().timeIntervalSince1970
        let endTimestampInDays = nextWateringDate.timeIntervalSince1970
        
        let secondsRemaining = endTimestampInDays - startTimestampInDays
        return timeIntervalToString(seconds: secondsRemaining)
    }
    
    private func timeIntervalToString(seconds: TimeInterval) -> String {
        let minute = 60.0
        let hour = 3600.0
        let day = 86400.0
        let month = 2592000.0
        let year = 31536000.0

        if seconds < minute {
            let secondsString = Int(seconds) == 1 ? "second" : "seconds"
            return "\(Int(seconds)) \(secondsString)"
        } else if seconds < hour {
            let minutes = Int(seconds / minute)
            let minutesString = minutes == 1 ? "minute" : "minutes"
            return "\(minutes) \(minutesString)"
        } else if seconds < day {
            let hours = Int(seconds / hour)
            let hoursString = hours == 1 ? "hour" : "hours"
            return "\(hours) \(hoursString)"
        } else if seconds < month {
            let days = Int(seconds / day)
            let daysString = days == 1 ? "day" : "days"
            return "\(days) \(daysString)"
        } else if seconds < year {
            let months = Int(seconds / month)
            let monthsString = months == 1 ? "month" : "months"
            return "\(months) \(monthsString)"
        } else {
            let years = Int(seconds / year)
            let yearsString = years == 1 ? "year" : "years"
            return "\(years) \(yearsString)"
        }
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue}
    }
    
    var location: String {
        get { location_ ?? "" }
        set { location_ = newValue}
    }
    
    var interval: WaterTimeInterval {
        get { WaterTimeInterval(rawValue: interval_ ?? "") ?? .day }
        set { interval_ = newValue.rawValue }
    }
    
    var lastWatered: Date {
        get { lastWatered_ ?? Date() }
        set { lastWatered_ = newValue}
    }
}

extension Plant {
    static let notificationCategoryId = "WaterPlantNotification"

    static func scheduleWaterReminderNotification() async {
        // Check if app has permission to schedule notifications, may ask user for permission
        guard await authorizeIfNeeded() else { return }
        
        var context = PersistenceController.shared.container.viewContext
        
        // Clear pending notifications
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        // Fetch all plants
        var plants: [Plant] = []
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        do {
            plants = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching plant data: \(error)")
        }
        
        // Group plants by their nextWateringDate
        let groupedPlants = Dictionary(grouping: plants) { $0.nextWateringDate }
        
        // Iterate through grouped plants and create notification requests
        for (nextWateringDate, plants) in groupedPlants {
            let content = UNMutableNotificationContent()
            content.title = "Water Reminder"
            content.body = "You have \(plants.count) plants ready to be watered."
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = Plant.notificationCategoryId
            
            // Create the notification request
            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: nextWateringDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Schedule the request
            try? await notificationCenter.add(request)
        }
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
                return false
            }
        case .denied, .provisional, .ephemeral:
            return false
        @unknown default:
            return false
        }
    }
}

enum WaterTimeInterval: String, CaseIterable, Identifiable {
    case day
    case week
    case month
    
    var id: Self { self }
    
    var calendarUnit: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        }
    }
}

/*
 Notes:
 1. Why does are some attributes optional?
    - When you create your entity the default setting for Boolean and Double is to use scalar (primitive) types and they are non-optional because Objective-C (which is what Core Data is based on) can't handle optional scalar types.
    - "Optional" means something different to Core Data than it does to Swift.
        - If a Core Data attribute is not optional, it must have a non-nil value when you save changes. At other times Core Data doesn't care if the attribute is nil.
        - If a Swift property is not optional, it must have a non-nil value at all times after initialization is complete.[StackOverflow](https://stackoverflow.com/questions/33548350/xcode-nsmanagedobject-subclass-contains-optionals-when-they-are-marked-as-non-op/33552046#33552046)
 2. How to make Xcode auto create these entitiy files?
    - Click on .xcdatamodeld file, Editor -> Create NSManagedObject...
 3. You can't create NSObjects without using context
    - You can create another class as a wrapper for the core data class
 */
