//
//  DetailEditViewModel.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/4/23.
//

import Foundation
import CoreData
import SwiftUI
import PhotosUI


@MainActor
class AddEditPlantViewModel: ObservableObject {
    @Published var name = ""
    @Published var location = ""
    @Published var lastWatered = Date()
    @Published var waterTimeInterval: WaterTimeInterval = .week
    @Published var unit = 1
    @Published var isNotificationEnabled = true
    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    var plant: Plant?
    var context = PersistenceController.shared.container.viewContext
    var plantService = PlantService()
    
    var plantParts: PlantParts {
        PlantParts(name: name, location: location, lastWateredDate: lastWatered, interval: waterTimeInterval, unit: unit, imageState: imageState)
    }
    
    var waterIntervalString: String {
        return unit == 1 ? "\(unit) \(waterTimeInterval.rawValue)" : "\(unit) \(waterTimeInterval.rawValue)s"
    }
    
    var toolbarButtonText: String {
        return plant != nil ? "Update" : "Add"
    }

    init(plant: Plant? = nil) {
        guard let plant = plant else { return }
        
        self.plant = plant
        name = plant.name
        location = plant.location
        lastWatered = plant.lastWateredDate
        waterTimeInterval = plant.interval
        unit = Int(plant.unit)
        
        do {
            if let imageFilePath = plant.imageFilePath {
                let data = try Data(contentsOf: URL(filePath: imageFilePath))
                imageState = .success(data)
            }
        } catch {
            imageState = .empty
        }
    }
    
    func addUpdatePlantButtonTapped() {
        if let plant {
            updatePlant(plant)
        } else {
            addPlant()
        }
    }
    
    func addPlant() {
        do {
            try plantService.addPlant(using: plantParts)
        } catch {
            // Handle saving error here
        }
    }
    
    func updatePlant(_ plant: Plant) {
        do {
            try plantService.updatePlant(plant, using: plantParts, oldNextWateringDate: plant.nextWateringDate)
        } catch {
            // Handle updating error here
        }
    }
        
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    return
                }
                switch result {
                case .success(let data?):
                    self.imageState = .success(data)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Data)
    case failure(Error)
}
