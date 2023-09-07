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

class AddEditPlantViewModel: ObservableObject {
    @Published var name = ""
    @Published var location = ""
    @Published var lastWatered = Date()
    @Published var waterTimeInterval: WaterTimeInterval = .day
    @Published var unit = 0
    @Published var isNotificationEnabled = false
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
    
    var context = PersistenceController.shared.container.viewContext
    
    var plant: Plant?

    init(plant: Plant? = nil) {
        guard let plant = plant else { return }
        self.plant = plant
        name = plant.name
        location = plant.location
        lastWatered = plant.lastWatered
        waterTimeInterval = plant.interval
        unit = Int(plant.unit)
        isNotificationEnabled = plant.isNotificationEnabled
        do {
            if let imageFilePath = plant.imageFilePath,
               let data = try? Data(contentsOf: URL(filePath: imageFilePath)) {
                imageState = .success(data)
            }
        } catch {
            imageState = .failure(error)
        }
    }
    
    func addPlant() {
        // 1. Create a new instance of your Core Data entity.
        let plant = Plant(context: context)
        // 2. Set the properties of the managed object as needed.
        plant.name = name
        plant.location = location
        plant.lastWatered = lastWatered
        plant.interval = waterTimeInterval
        plant.unit = Int32(unit)
        plant.isNotificationEnabled = isNotificationEnabled
        
        // Save the image data to the file path
        switch imageState {
        case .success(let data):
            // Create a unique file name or generate a URL for the image
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            print(documentsDirectory.path)
            let fileURL = documentsDirectory.appending(path: "\(UUID().uuidString).jpg")
            print(fileURL.path)
            try? data.write(to: fileURL)
            plant.imageFilePath = fileURL.path
        default:
            break
        }
        
        // 3. Save the managed object context to persist the new object to the Core Data store.
        do {
            try context.save()
            print("Created plant successfully\n\(plant)")
        } catch {
            print("Erroring creating plant\n\(error)")
        }
    }
    
    func updatePlant() {
        guard let plant = plant else { return }
        plant.name = name
        plant.location = location
        plant.lastWatered = lastWatered
        plant.interval = waterTimeInterval
        plant.unit = Int32(unit)
        plant.isNotificationEnabled = isNotificationEnabled
        
        // Save the image data to the file path
        switch imageState {
        case .success(let data):
            // Create a unique file name or generate a URL for the image
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            print(documentsDirectory.path)
            let fileURL = documentsDirectory.appending(path: "\(UUID().uuidString).jpg")
            print(fileURL.path)
            try? data.write(to: fileURL)
            plant.imageFilePath = fileURL.path
        default:
            break
        }
        
        do {
            try context.save()
            print("Updated plant successfully\n\(plant)")
        } catch {
            print("Erroring creating plant\n\(error)")
        }
    }
    
    // MARK: - Private Methods
    
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