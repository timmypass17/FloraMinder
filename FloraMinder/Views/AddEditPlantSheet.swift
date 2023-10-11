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
                }
                
                Section("Water Information") {
                    NavigationLink {
                        SelectWaterIntervalView(waterTimeInterval: $addEditPlantViewModel.waterTimeInterval, unit: $addEditPlantViewModel.unit)
                    } label: {
                        HStack {
                            Text("Water Every")
                            Spacer()
                            Text(addEditPlantViewModel.waterIntervalString)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    DatePicker("Last Watered",
                               selection: $addEditPlantViewModel.lastWatered,
                               in: Date.distantPast...Date.now,
                               displayedComponents: .date)
                }

            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresentingAddEditPlantSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(addEditPlantViewModel.toolbarButtonText) {
                        addEditPlantViewModel.addUpdatePlantButtonTapped()
                        isPresentingAddEditPlantSheet = false
                    }
                }
            }
        }
    }
    
    
}

struct NewPlantSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPlantSheet(isPresentingAddEditPlantSheet: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
