//
//  Plant.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//
//

import Foundation
import CoreData


@objc(Plant)
public class Plant: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }
    
    @nonobjc public class func delete(plant: Plant, with context: NSManagedObjectContext) {
        context.delete(plant)
        do {
            try context.save()
            print("Removed plant successfully\n\(plant)")
        } catch {
            print("Error removing plant\n\(error)")
        }
    }

    @NSManaged public var name_: String?
    @NSManaged public var location_: String?
    @NSManaged public var interval_: String?
    @NSManaged public var unit: Int32
    @NSManaged public var lastWatered_: Date?
    @NSManaged public var notificationID: UUID?
    @NSManaged public var isNotificationEnabled: Bool
    @NSManaged public var imageFilePath: String?

}

extension Plant : Identifiable { }

extension Plant {
    
    var nextWateringDate: Date {
        let nextWateringDate = Calendar.current.date(byAdding: interval.calendarUnit, value: Int(unit), to: lastWatered) ?? Date()
        // Set the time components to noon (12:00 PM)
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: nextWateringDate) ?? Date()
    }
    
    var daysUntilNextWatering: Int {
        let secondsPerDay: TimeInterval = 86400
        // Convert the date to a timestamp (integer) in seconds
        let startTimestampInDays = Int(Date().timeIntervalSince1970 / secondsPerDay)
        let endTimestampInDays = Int(nextWateringDate.timeIntervalSince1970 / secondsPerDay)
        
        let daysRemaining = endTimestampInDays - startTimestampInDays
        return daysRemaining
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
