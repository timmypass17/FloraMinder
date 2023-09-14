//
//  ContentView.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/26/23.
//

import SwiftUI

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
            
            List {
                ForEach(plants) { section in
                    Section(header: Text("\(section.id) (\(section.count))")) {
                        ForEach(section) { plant in
                            NavigationLink {
                                DetailView(plant: plant)
                            } label: {
                                PlantCellView(plant: plant)
                                    .padding(.vertical, 5)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    plant.waterPlant(context: context)
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
            .listStyle(.plain)
            .navigationTitle("My Plants")
            .toolbar {
                ToolbarItem {
                    Button {
                        homeViewModel.isPresentingNewPlantView = true
                    } label: {
                        Label("Add Plant", systemImage: "plus")

                    }
                }
            }
        }
        .sheet(isPresented: $homeViewModel.isPresentingNewPlantView) {
            AddEditPlantSheet(plant: nil, isPresentingAddEditPlantSheet: $homeViewModel.isPresentingNewPlantView)
                .environment(\.managedObjectContext, context)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
