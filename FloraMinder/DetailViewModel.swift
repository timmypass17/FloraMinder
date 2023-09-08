//
//  DetailViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/7/23.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var isPresentingEditPlantSheet = false
    @Published var waterButtonIsEnabled = true
    
    var context = PersistenceController.shared.container.viewContext
    var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant // same ref to @ObservedObject plant in detailview, doesn't update ui if placed as @Published in viewmodel
    }
    
    func waterPlantButtonTapped() async {
        waterButtonIsEnabled = false
        plant.lastWatered = Date()
        
        do {
            try context.save()
            print("Watered plant successfully\n\(plant)")
        } catch {
            print("Erroring watering plant\n\(error)")
        }
    }
}
