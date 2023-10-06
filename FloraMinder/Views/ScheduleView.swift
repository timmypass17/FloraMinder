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
                    
                    Text("Upcoming Tasks")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.horizontal])
                    
                    if let dateSelected {
                        if plants.isEmpty {
                            Text("No plants to water on \(dateSelected.date?.formatted(date: .abbreviated, time: .omitted) ?? "\(Date().formatted(date: .abbreviated, time: .omitted))").")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                            
                        } else {
                            ForEach(plants) { section in
                                Text(section.id)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                LazyVGrid(columns: columns, spacing: 25) {
                                    
                                    ForEach(section) { plant in
                                        NavigationLink {
                                            DetailView(plant: plant)
                                        } label: {
                                            ScheduleCellView(plant: plant)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.top, 4)

                        }
                    } else {
                        if plants.isEmpty {
                            Text("No plants to water on \(dateSelected?.date?.formatted(date: .abbreviated, time: .omitted) ?? "\(Date().formatted(date: .abbreviated, time: .omitted))").")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(plants) { section in
                                VStack {
                                    Text(getHumanReadableDateString(from: section.id))
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(section) { plant in
                                                NavigationLink {
                                                    DetailView(plant: plant)
                                                } label: {
                                                    ScheduleCellView(plant: plant)
                                                }
                                                .buttonStyle(.plain)
                                                .frame(width: geometry.size.width * 0.22)
                                            }
                                        }
                                    }
                                    Divider()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.top, 4)
                        }
                    }
                    
                }
                .navigationTitle("Calendar")
                .onChange(of: dateSelected){ newValue in
                    // https://developer.apple.com/forums/thread/122426
                    if let newValue, let date = newValue.date {
                        plants.nsPredicate = Plant.predicateForDate(date: date)
                    } else {
                        plants.nsPredicate = nil
                    }
                }
            }
        }
    }
}

func getHumanReadableDateString(from dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy" // Adjust this format to match your date string format
    
    if let date = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        
        if currentDate > date {
            return "Past Due"
        } else if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else  {
            return dateString
        }
    }
    
    return "Invalid Date"
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

