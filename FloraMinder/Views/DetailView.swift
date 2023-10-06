//
//  DetailView.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject var detailViewModel: DetailViewModel
    @ObservedObject var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(plant: plant))
        
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Plant") {
                    if let imageFilePath = detailViewModel.plant.imageFilePath,
                       let image = UIImage(contentsOfFile: imageFilePath) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipShape(Circle())
                        
                    } else {
                        Image(systemName: "camera.macro")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .frame(width: 150, height: 150)
                            .background {
                                Circle().fill(.regularMaterial)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    HStack {
                        Label("Plant Name", systemImage: "leaf")
                        Spacer()
                        Text(detailViewModel.plant.name)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Location", systemImage: "house")
                        Spacer()
                        Text(detailViewModel.plant.location)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Watering Information") {
                    HStack {
                        Label("Water Every", systemImage: "calendar")
                        
                        Spacer()
                        
                        Text(detailViewModel.plant.waterTimeIntervalFormatted)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Last Watered", systemImage: "drop")
                        Spacer()
                        Text("\(plant.lastWateredDate.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Water Due", systemImage: "alarm")
                        
                        Spacer()
                        Text("\(detailViewModel.plant.nextWateringDate.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Time Remaining", systemImage: "clock")
                        
                        Spacer()
                        Text("\(detailViewModel.plant.daysUntilNextWateringFormatted)")
                            .foregroundColor(.secondary)
                        
                    }
                    
                }

            }
            
            Button {
                Task {
                    await detailViewModel.waterPlantButtonTapped()
                }
            } label: {
                Label("Water Plant", systemImage: "drop")
                    .labelStyle(.titleAndIcon)
                    .padding(4)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .buttonStyle(.bordered)
            .tint(.blue)
            .disabled(!detailViewModel.waterButtonIsEnabled)
            
        }
        .onAppear {
            print("Last: \(plant.lastWateredDate)")
            print("Next: \(plant.nextWateringDate)")

        }
        .navigationTitle(detailViewModel.plant.name)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    detailViewModel.isPresentingEditPlantSheet = true
                }
            }
        }
        .sheet(isPresented: $detailViewModel.isPresentingEditPlantSheet) {
            AddEditPlantSheet(
                plant: detailViewModel.plant,
                isPresentingAddEditPlantSheet: $detailViewModel.isPresentingEditPlantSheet)
            .environment(\.managedObjectContext, context)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(plant: Plant(entity: Plant.entity(), insertInto: nil))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
