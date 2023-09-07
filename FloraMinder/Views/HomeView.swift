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
        sectionIdentifier: \.location_!,
        sortDescriptors: [SortDescriptor(\.name_, order: .forward)]
    )
    private var plants: SectionedFetchResults<String, Plant>
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(plants) { section in
                    Section(header: Text("\(section.id) (\(section.count))")) {
                        ForEach(section) { plant in
                            // TODO: Maybe use new navigation
                            NavigationLink {
                                DetailView(plant: plant)
                            } label: {
                                PlantCellView(plant: plant)
                                    .padding(.vertical, 5)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    // Water Plant
                                } label: {
                                    Label("Water Plant", systemImage: "drop")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Plant.delete(plant: plant, with: context)
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