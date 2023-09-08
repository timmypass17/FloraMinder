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
    var context = PersistenceController.shared.container.viewContext

    func deletePlant(_ plant: Plant) {        
        context.delete(plant)
        
        do {
            try context.save()
            print("Removed plant successfully\n\(plant)")
        } catch {
            print("Error removing plant\n\(error)")
        }
    }
}
