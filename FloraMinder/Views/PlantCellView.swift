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
        if plant.isReadyToWater {
            return "sparkles"
        } else {
            return "clock"
        }
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
                        Circle().fill(.regularMaterial)
                    }
            }

            VStack(alignment: .leading) {
                Text(plant.name)
                
                TimelineView(.periodic(from: plant.lastWateredDate, by: oneDayInSeconds)) { context in
                    ProgressView(value: Float(plant.daysPassedSinceLastWatering), total: Float(plant.totalDaysBetweenWatering)) {
                        HStack {
                            Label("Every \(plant.unit) \(plant.interval.rawValue)", systemImage: "calendar")
                                .labelStyle(.titleAndIcon)
                            Spacer()
                            // Use sparkles to show ready to water
                            Label("\(plant.daysUntilNextWateringFormatted)", systemImage: imageString)
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
}

struct PlantCellView_Previews: PreviewProvider {
    static var previews: some View {
        PlantCellView(plant: Plant(entity: Plant.entity(), insertInto: nil))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .padding()
            .previewLayout(.sizeThatFits)
        
    }
}
