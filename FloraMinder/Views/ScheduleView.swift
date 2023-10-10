////
////  ScheduleView.swift
////  PlantWateringApp
////
////  Created by Timmy Nguyen on 8/29/23.
////


import SwiftUI

struct ScheduleView: View {
    @State private var dateSelected: DateComponents?

    @SectionedFetchRequest<String, Plant>(
        sectionIdentifier: \.nextWateringDateString,
        sortDescriptors: [
            SortDescriptor(\.nextWateringDate_, order: .forward), // Sort sections alphabetically
            SortDescriptor(\.name_, order: .forward)      // Sort items within sections
        ]
    )
    private var plants: SectionedFetchResults<String, Plant>
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    CalendarView(
                        dateSelected: $dateSelected,
                        interval: DateInterval(start: .distantPast, end: .distantFuture)
                    )
                    
                    Divider()
                        .offset(y: -15)
                    
                    Text("Upcoming Tasks")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.horizontal])

                    if plants.isEmpty {
                        EmptyTaskView(dateComponents: dateSelected)
                    } else {
                        ForEach(plants) { section in
                            Text(formatDate(section.id))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            LazyVGrid(columns: columns) {
                                ForEach(section) { plant in
                                    NavigationLink {
                                        DetailView(plant: plant)
                                    } label: {
                                        ScheduleCellView(plant: plant)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            Divider()
                            
                        }
                        .padding(.top, 4)
                    }
                    
                }
                .navigationTitle("Calendar")
                .onChange(of: dateSelected){ newValue in
                    // https://developer.apple.com/forums/thread/122426
                    // using Date type doesn't return nil but DateComponents does
                    if let newValue, let date = newValue.date {
                        plants.nsPredicate = Plant.predicateForDate(date: date)
                    } else {
                        plants.nsPredicate = nil
                    }
                }
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
            if Calendar.current.isDateInToday(date) {
                return "Today"
            }
        }
        
        return dateString
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

struct EmptyTaskView: View {
    var dateComponents: DateComponents?
    
    var body: some View {
        
        Text("No plants to water on \(dateComponents?.date?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
}
