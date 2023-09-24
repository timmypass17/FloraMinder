//
//  DetailViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/7/23.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    @Published var isPresentingEditPlantSheet = false
    @Published var waterButtonIsEnabled = true
    
    var context = PersistenceController.shared.container.viewContext
    var plant: Plant
    
    init(plant: Plant) {
        // plant is same ref to @ObservedObject plant in detailview, doesn't update ui if placed as @Published in viewmodel for some reason
        self.plant = plant
    }
    
    func waterPlantButtonTapped() async {
        waterButtonIsEnabled = false
        plant.water(context: context)
    }
}
