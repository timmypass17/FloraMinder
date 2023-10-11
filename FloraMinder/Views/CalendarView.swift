//
//  CalendarView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/22/23.
//

import Foundation
import SwiftUI

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = UICalendarView
    
    @FetchRequest(sortDescriptors: [])
    private var plants: FetchedResults<Plant>
    @Binding var dateSelected: DateComponents?
    let interval: DateInterval
        
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.availableDateRange = interval
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        uiView.reloadDecorations(forDateComponents: Array(CalendarModel.shared.datesModified), animated: true)
        CalendarModel.shared.datesModified.removeAll()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = parent.plants
                .filter { Calendar.current.isDate($0.nextWateringDate, inSameDayAs: dateComponents.date!)}

            if foundEvents.count == 0 {
                return nil
            } else {
                return .default(color: .systemOrange)
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
    
}
