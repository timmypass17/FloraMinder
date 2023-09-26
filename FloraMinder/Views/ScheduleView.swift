////
////  ScheduleView.swift
////  PlantWateringApp
////
////  Created by Timmy Nguyen on 8/29/23.
////


import SwiftUI

struct ScheduleView: View {
    @State private var dateSelected: DateComponents?
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name_)],
        predicate: Plant.predicateForDate(date: .now),
        animation: .default
    )
    var plants: FetchedResults<Plant>
        
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(
                    dateSelected: $dateSelected,
                    interval: DateInterval(start: .distantPast, end: .distantFuture)
                )
                Divider()
                
                Text("Tasks")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top])
                
                    if plants.isEmpty {
                        Text("No plants to water on \(dateSelected?.date?.formatted(date: .numeric, time: .omitted) ?? "\(Date().formatted(date: .numeric, time: .omitted))").")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()

                    } else {
                        LazyVGrid(columns: columns, spacing: 25) {
                            ForEach(plants, id: \.self) { plant in
                                NavigationLink {
                                    DetailView(plant: plant)
                                } label: {
                                    ScheduleCellView(plant: plant)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

            }
            .navigationTitle("Water Schedule")
            .onChange(of: dateSelected){ newValue in
                // https://developer.apple.com/forums/thread/122426
                if let newValue, let date = newValue.date {
                    plants.nsPredicate = Plant.predicateForDate(date: date)
                }
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

