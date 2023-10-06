//
//  ContentView.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/26/23.
//

import SwiftUI
import WidgetKit

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @SectionedFetchRequest<String, Plant>(
        sectionIdentifier: \.location,
        sortDescriptors: [
            SortDescriptor(\.location_, order: .forward), // Sort sections alphabetically
            SortDescriptor(\.name_, order: .forward)      // Sort items within sections
            ]
    )
    private var plants: SectionedFetchResults<String, Plant>
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(plants) { section in
                        Section(header: Text("\(section.id)")) {
                            ForEach(section) { plant in
                                NavigationLink {
                                    DetailView(plant: plant)
                                } label: {
                                    PlantCellView(plant: plant)
                                        .padding(.vertical, 5)
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        plant.water(context: context)
                                    } label: {
                                        Label("Water Plant", systemImage: "drop")
                                    }
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        homeViewModel.deletePlant(plant)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $homeViewModel.isPresentingNewPlantView) {
                    AddEditPlantSheet(plant: nil, isPresentingAddEditPlantSheet: $homeViewModel.isPresentingNewPlantView)
                        .environment(\.managedObjectContext, context)
                }
                .toolbar {
                    ToolbarItem {
                        Button {
//                            WidgetCenter.shared.reloadTimelines(ofKind: "FloraMinderWidget")

                            homeViewModel.isPresentingNewPlantView = true
                        } label: {
                            Label("Add Plant", systemImage: "plus")
                            
                        }
                    }
                }
                .listStyle(.plain)
            .navigationTitle("My Garden")
            }
            .overlay {
                if plants.isEmpty {
                    Text("Your plants will show up here.\nClick the \"+\" sign to get started!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
