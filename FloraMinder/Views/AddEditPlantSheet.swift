//
//  NewPlantSheet.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI

struct AddEditPlantSheet: View {
    @Environment(\.managedObjectContext) var context
    @StateObject var addEditPlantViewModel: AddEditPlantViewModel
    @Binding var isPresentingAddEditPlantSheet: Bool
            
    init(plant: Plant? = nil, isPresentingAddEditPlantSheet: Binding<Bool>) {
        self._addEditPlantViewModel = StateObject(wrappedValue: AddEditPlantViewModel(plant: plant))
        self._isPresentingAddEditPlantSheet = isPresentingAddEditPlantSheet
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    EditableCircularPlantImage(imageSelection: $addEditPlantViewModel.imageSelection, imageState: addEditPlantViewModel.imageState)
                        .frame(maxWidth: .infinity)
                }
                Section("Plant Information") {
                    TextField("Plant Name", text: $addEditPlantViewModel.name)
                    TextField("Location", text: $addEditPlantViewModel.location)
                    DatePicker("Last Watered", selection: $addEditPlantViewModel.lastWatered, displayedComponents: .date)
                }
                
                Section("Water Interval") {
                    NavigationLink {
                        SelectWaterIntervalView(waterTimeInterval: $addEditPlantViewModel.waterTimeInterval, unit: $addEditPlantViewModel.unit)
                    } label: {
                        HStack {
                            Text("Water Every")
                            Spacer()
                            Text("\(addEditPlantViewModel.unit) \(addEditPlantViewModel.waterTimeInterval.rawValue)s")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section {
                    Toggle("Enable Watering Reminders", isOn: $addEditPlantViewModel.isNotificationEnabled)
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Receive a notification at noon to water plant.\n*You can modify this later in the settings.")
                }

            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentingAddEditPlantSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if addEditPlantViewModel.plant == nil {
                        Button("Add") {
                            addEditPlantViewModel.addPlant()
                            isPresentingAddEditPlantSheet = false
                        }
                    } else {
                        Button("Save") {
                            addEditPlantViewModel.updatePlant()
                            isPresentingAddEditPlantSheet = false
                        }
                    }
                }
            }
        }
//        NavigationStack {
//            DetailEditView(detailEditViewModel: detailEditViewModel)
//                .navigationTitle("Add New Plant 🌱")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button("Dismiss") {
//                            detailEditViewModel.isPresentingNewPlantView = false
//                        }
//                    }
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button("Add") {
//                            detailEditViewModel.addPlant()
//                            detailEditViewModel.isPresentingNewPlantView = false
//                        }
//                    }
//                }
//        }
    }
    
    
}

struct NewPlantSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPlantSheet(isPresentingAddEditPlantSheet: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
