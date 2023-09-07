//
//  DetailViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/7/23.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var isPresentingEditPlantSheet = false
    @Published var plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
    }
}
