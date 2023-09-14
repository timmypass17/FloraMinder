//
//  PlantCell.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/26/23.
//

import SwiftUI

struct PlantCellView: View {
    @ObservedObject var plant: Plant
    
    var imageString: String {
        if plant.plantIsReadyToWater {
            return "sparkles"
        } else {
            return "clock"
        }
    }
    
    var body: some View {
        HStack {
            if let imageFilePath = plant.imageFilePath,
                let image = UIImage(contentsOfFile: imageFilePath) {
                Image(uiImage: image )
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "camera.macro")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(.regularMaterial)
                    }
            }

            VStack(alignment: .leading) {
                Text(plant.name)
                
                // Updates UI every minute
                TimelineView(.everyMinute) { context in
                    ProgressView(value: currentWaterTime(), total: totalWaterTime()) {
                        HStack {
                            Label("Every \(plant.unit) \(plant.interval.rawValue)", systemImage: "calendar")
                                .labelStyle(.titleAndIcon)
                            Spacer()
                            // Use sparkles to show ready to water
                            Label("\(plant.timeRemainingToWaterPlant)", systemImage: imageString)
                                .labelStyle(.titleAndIcon)
                                .symbolRenderingMode(.multicolor)
                        }
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    }
                    .progressViewStyle(.linear)
                }
            }
            .padding(.leading, 4)
        }
    }
    
    func currentWaterTime() -> Float {
        let startTimestampInDays = Int(plant.lastWatered.timeIntervalSince1970)
        let endTimestampInDays = Int(Date().timeIntervalSince1970)
        let progress = endTimestampInDays - startTimestampInDays
        
        return Float(progress)
    }
    
    func totalWaterTime() -> Float {
        // Convert the date to a timestamp (integer) in seconds
        let startTimestampInDays = Int(plant.lastWatered.timeIntervalSince1970)
        let endTimestampInDays = Int(plant.nextWateringDate.timeIntervalSince1970)
        
        let total = endTimestampInDays - startTimestampInDays
        return Float(total)
    }
}

struct PlantCellView_Previews: PreviewProvider {
    static var previews: some View {
        PlantCellView(plant: Plant(entity: Plant.entity(), insertInto: nil))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .padding()
            .previewLayout(.sizeThatFits)
        
    }
}
