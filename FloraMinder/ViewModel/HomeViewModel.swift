//
//  HomeViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/5/23.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    @Published var isPresentingNewPlantView = false
    @Published var isPresentingErrorAlert = false
    
    var context = PersistenceController.shared.container.viewContext
    let plantService = PlantService()

    func swipePlantToDelete(_ plant: Plant) {        
        do {
            try plantService.deletePlant(plant)
        } catch {
            // Handle deletion error
            isPresentingErrorAlert = true
        }
    }
}
