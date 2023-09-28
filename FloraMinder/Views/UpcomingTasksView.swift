//
//  UpcomingTasksView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/26/23.
//

import SwiftUI

struct UpcomingTasksView: View {
    @SectionedFetchRequest<String, Plant>(
        sectionIdentifier: \.nextWateringDateString,
        sortDescriptors: [
            SortDescriptor(\.nextWateringDate_, order: .forward), // Sort sections alphabetically
            SortDescriptor(\.name_, order: .forward)      // Sort items within sections
            ]
    )
    private var plants: SectionedFetchResults<String, Plant>
        
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
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
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
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .navigationTitle("Upcoming Tasks")
            }
        }
    }
}

struct UpcomingTasksView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingTasksView()
    }
}