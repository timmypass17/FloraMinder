//
//  AddEditPlant.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI
import PhotosUI
import CoreData

struct DetailEditView: View {
    @Environment(\.managedObjectContext) var context
//    @StateObject var viewModel = ProfileModel()
    
    @ObservedObject var detailEditViewModel: AddEditPlantViewModel
    
    var body: some View {
        Form {
            Section("Photo") {
                EditableCircularPlantImage(imageSelection: $detailEditViewModel.imageSelection, imageState: detailEditViewModel.imageState)
                    .frame(maxWidth: .infinity)
            }
            Section("Plant Information") {
                TextField("Plant Name", text: $detailEditViewModel.name)
                TextField("Location", text: $detailEditViewModel.location)
                DatePicker("Last Watered", selection: $detailEditViewModel.lastWatered, displayedComponents: .date)
            }
            
            Section("Water Interval") {
                NavigationLink {
                    SelectWaterIntervalView(waterTimeInterval: $detailEditViewModel.waterTimeInterval, unit: $detailEditViewModel.unit)
                } label: {
                    HStack {
                        Text("Water Every")
                        Spacer()
                        Text("\(detailEditViewModel.unit) \(detailEditViewModel.waterTimeInterval.rawValue)s")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section {
                Toggle("Enable Watering Reminders", isOn: $detailEditViewModel.isNotificationEnabled)
            } header: {
                Text("Notifications")
            } footer: {
                Text("Receive a notification at noon to water plant.\n*You can modify this later in the settings.")
            }

        }
    }
}

struct AddEditPlant_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(detailEditViewModel: AddEditPlantViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
