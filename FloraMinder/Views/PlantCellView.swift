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
        return plant.isReadyToWater ? "sparkles" : "clock"
    }
    
    let oneDayInSeconds: TimeInterval = 24 * 60 * 60
    
    var body: some View {
        HStack {
            if let imageFilePath = plant.imageFilePath,
                let image = UIImage(contentsOfFile: imageFilePath) {
                Image(uiImage: image )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "camera.macro")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(.secondary.opacity(0.5))
                    }
            }

            VStack(alignment: .leading) {
                Text(plant.name)
                
                TimelineView(.periodic(from: plant.lastWateredDate, by: oneDayInSeconds)) { context in
                    ProgressView(value: Float(plant.daysPassedSinceLastWatering), total: Float(plant.totalDaysBetweenWatering)) {
                        HStack {
                            Label("Every \(plant.waterTimeIntervalFormatted)", systemImage: "calendar")
                                .labelStyle(.titleAndIcon)

                            Spacer()
                            // Use sparkles to show ready to water
                            Label("\(plant.daysUntilNextWateringFormatted)", systemImage: imageString)
                                .labelStyle(.titleAndIcon)
                                .symbolRenderingMode(.multicolor)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .progressViewStyle(.linear)
                }
            }
            .padding(.leading, 4)
        }
    }
}

struct PlantCellView_Previews: PreviewProvider {
    static var samplePlant: Plant {
        let plant = Plant(entity: Plant.entity(), insertInto: nil)
        plant.name = "Cactus"
        return plant
    }
    static var previews: some View {
        PlantCellView(plant: samplePlant)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
