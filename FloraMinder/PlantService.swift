////
////  PlantService.swift
////  FloraMinder
////
////  Created by Timmy Nguyen on 10/10/23.
////
//
//import Foundation
//
//class PlantService {
//    
//    var context = PersistenceController.shared.container.viewContext
//    
//    func addPlant(name: String, location: String, interval: String, unit: String, nextWateringDate: Date, imageFilePath: String) async {
//        CalendarModel.shared.changedDate = plant.nextWateringDate
//        await savePlant(plant)
//    }
//    
//    
//    
//    func savePlant(_ plant: Plant) async {
//        do {
//            try context.save()
//            print("Created plant successfully\n\(plant)")
//        } catch {
//            print("Erroring creating plant\n\(error)")
//        }
//    }
//    
//    func updatePlant(_ plant: Plant) async {
//        CalendarModel.shared.changedDate = plant.nextWateringDate   // original due date
//        
//        let newWateringDate = Calendar.current.date(byAdding: waterTimeInterval.calendarUnit, value: Int(unit), to: lastWatered) ?? Date()
//
//        plant.name = name
//        plant.location = location
//        plant.nextWateringDate = newWateringDate
//        plant.interval = waterTimeInterval
//        plant.unit = Int32(unit)
//        
//        CalendarModel.shared.movedDate = newWateringDate // new moved due date
//
//        
//        // Save the image data to the file path
//        switch imageState {
//        case .success(let data):
//            // Create a unique file name or generate a URL for the image
//            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            print(documentsDirectory.path)
//            let fileURL = documentsDirectory.appending(path: "\(UUID().uuidString).jpg")
//            print(fileURL.path)
//            try? data.write(to: fileURL)
//            plant.imageFilePath = fileURL.path
//        default:
//            break
//        }
//        
//        do {
//            try context.save()
//            print("Updated plant successfully\n\(plant)")
//        } catch {
//            print("Erroring creating plant\n\(error)")
//        }
//    }
//    
//}
