//
//  PlantCell.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/26/23.
//

import SwiftUI

struct PlantCellView: View {
    @ObservedObject var plant: Plant
    
    var body: some View {
        HStack {
            if let imageFilePath = plant.imageFilePath,
                let image = UIImage(contentsOfFile: imageFilePath) {
                Image(uiImage: image )
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "leaf.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Circle().fill(.green).frame(width: 50, height: 50))
                    .padding(.trailing)
            }
//            else {
//                Image(systemName: "leaf.fill")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .background(Circle().fill(.green).frame(width: 50, height: 50))
//                    .padding(.trailing)
//            }
            
            VStack(alignment: .leading) {
                Text(plant.name)
                
                ProgressView(value: progress(), total: total()) {
                    HStack {
                        Text("Water every \(plant.unit) \(plant.interval.rawValue)") // maybe make this section
                        Spacer()
                        Label("\(plant.daysUntilNextWatering) Days", systemImage: "clock")
                            .labelStyle(.titleAndIcon)
                        // USe sparkles to show ready to water
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                }
                .progressViewStyle(.linear)
            }
        }
    }
    
    func progress() -> Float {
//        let secondsPerDay: TimeInterval = 86400
//        // Convert the date to a timestamp (integer) in seconds
//        let startTimestampInDays = Int(plant.lastWatered.timeIntervalSince1970 / secondsPerDay)
//        let endTimestampInDays = Int(Date().timeIntervalSince1970 / secondsPerDay)
//        let progress = endTimestampInDays - startTimestampInDays
        
        let startTimestampInDays = Int(plant.lastWatered.timeIntervalSince1970)
        let endTimestampInDays = Int(Date().timeIntervalSince1970)
        let progress = endTimestampInDays - startTimestampInDays
        
        return Float(progress)
    }
    
    func total() -> Float {
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
            .padding()
            .previewLayout(.sizeThatFits)
        
    }
}
