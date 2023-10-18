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
    @Published var waterTimeInterval: WaterTimeInterval = .day
    @Published var unit = 3
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
    @Published var isPresentingErrorAlert = false
    
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

    init(plant: Plant?) {
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
    
    func saveButtonTapped() {
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
            isPresentingErrorAlert = true
        }
    }
    
    func updatePlant(_ plant: Plant) {
        do {
            try plantService.updatePlant(plant, using: plantParts, oldNextWateringDate: plant.nextWateringDate)
        } catch {
            isPresentingErrorAlert = true
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
