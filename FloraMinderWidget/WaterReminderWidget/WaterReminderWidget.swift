//
//  FloraMinderWidget.swift
//  FloraMinderWidget
//
//  Created by Timmy Nguyen on 9/30/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct WaterReminderWidget: Widget {
    let kind: String = "FloraMinderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WaterReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Water Reminder")
        .description("Track today's plants that require watering.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WaterReminderWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    // Where does entry come frome?
    // - Entries come from a timeline provider. The timeline provider provides snapshots when WidgetKit wants just one entry
    var entry: SimpleEntry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            WaterReminderSmallView(plants: entry.plants)
        case .systemMedium:
            WaterReminderMediumView(plants: entry.plants)
        default:
            Text("Placeholder")
        }
    }
}

struct Provider: TimelineProvider {
    // Show before loading widget
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), plants: [])
    }
    
    // Gallery preview
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let viewContext = PersistenceController.preview.container.viewContext
        let request = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "nextWateringDate_ <= %@", Date() as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        
        let result = (try? viewContext.fetch(request)) ?? []

        let entry = SimpleEntry(date: Date(), plants: result)
        completion(entry)
    }
    
    // Gets data for widget (optional can refresh in the future)
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        do {
            let result = try getDailyPlantData()
            let entry = SimpleEntry(date: Date(), plants: result)
            
            // Note: reload timeline manually (.never) using WidgetCenter.shared.reload
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        } catch {
            
            print("Failed to get timeline: \(error.localizedDescription)")
        }
    }
    
    private func getDailyPlantData() throws -> [Plant] {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let request = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "nextWateringDate_ <= %@", Date() as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        let result = try viewContext.fetch(request)
        
        return result
    }
}

// Each specifies the date and time to update the widget’s content, and includes the data your widget needs to render its view.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let plants: [Plant]
}

struct FloraMinderWidget_Previews: PreviewProvider {
    static var previews: some View {
        WaterReminderWidgetEntryView(entry: SimpleEntry(date: Date(), plants: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WaterReminderWidgetEntryView(entry: SimpleEntry(date: Date(), plants: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
