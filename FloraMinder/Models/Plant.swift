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
import UIKit


@objc(Plant)
public class Plant: NSManagedObject {
    @NSManaged public var name_: String?
    @NSManaged public var location_: String?
    @NSManaged public var interval_: String?
    @NSManaged public var unit: Int32
    @NSManaged public var nextWateringDate_: Date?
    @NSManaged public var imageFilePath: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }
    
    static func predicateForDate(date: Date) -> NSPredicate {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        let predicate = NSPredicate(format: "nextWateringDate_ >= %@ AND nextWateringDate_ <= %@", startOfDay as NSDate, endOfDay as NSDate)
        
        return predicate
    }
    
    func water(context: NSManagedObjectContext) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        CalendarModel.shared.datesModified.insert(Calendar.current.dateComponents([.year, .month, .day], from: nextWateringDate))
        var newWateringDate = Calendar.current.date(byAdding: interval.calendarUnit, value: Int(unit), to: .now) ?? Date()
        newWateringDate = Calendar.current.startOfDay(for: newWateringDate)
        nextWateringDate_ = newWateringDate
        CalendarModel.shared.datesModified.insert(Calendar.current.dateComponents([.year, .month, .day], from: newWateringDate))

        do {
            try context.save()
            print("Watered plant successfully\n\(self)")
        } catch {
            print("Erroring watering plant\n\(error)")
        }
    }
}

extension Plant: Identifiable { }

extension Plant {
    typealias Day = Int
    var calendar: Calendar { Calendar.current }
    
    var lastWateredDate: Date {
        let lastWatered = calendar.date(byAdding: interval.calendarUnit, value: -Int(unit), to: nextWateringDate) ?? Date()
        return Calendar.current.startOfDay(for: lastWatered)
    }

    var daysRemainingUntillNextWatering: Day {
        let today = calendar.startOfDay(for: Date())
        let daysRemaining = calendar.dateComponents([.day], from: today, to: nextWateringDate).day ?? 0
        return max(daysRemaining, 0)
    }
    
    var daysPassedSinceLastWatering: Day {
        let today = calendar.startOfDay(for: Date())
        let days = calendar.dateComponents([.day], from: lastWateredDate, to: today).day ?? 0
        return days
    }
    
    var totalDaysBetweenWatering: Day {
        let days = calendar.dateComponents([.day], from: lastWateredDate, to: nextWateringDate).day ?? 0
        return days
    }
    
    var isReadyToWater: Bool {
        return Date() >= nextWateringDate
    }
    
    var isDueToday: Bool {
        return calendar.isDate(.now, inSameDayAs: nextWateringDate)
    }
    
    var daysUntilNextWateringFormatted: String {
        if daysRemainingUntillNextWatering == 0 {
            return "Today"
        } else if daysRemainingUntillNextWatering == 1 {
            return "1 day"
        } else {
            return "\(daysRemainingUntillNextWatering) days"
        }
    }
    
    var waterTimeIntervalFormatted: String {
        return unit == 1 ? "\(unit) \(interval.rawValue)" : "\(unit) \(interval.rawValue)s"
    }

    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue}
    }
    
    @objc // @objc attribute for it to function as a section identifier
    var location: String {
        get { location_ ?? "" }
        set { location_ = newValue}
    }
    
    var interval: WaterTimeInterval {
        get { WaterTimeInterval(rawValue: interval_ ?? "") ?? .day }
        set { interval_ = newValue.rawValue }
    }
    
    var nextWateringDate: Date {
        get { nextWateringDate_ ?? Date() }
        set { nextWateringDate_ = calendar.startOfDay(for: newValue) }
    }
    
    @objc
    var nextWateringDateString: String {
        get { nextWateringDate_?.formatted(date: .abbreviated, time: .omitted) ?? "" }
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
