//
//  ScheduleCellView.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 9/24/23.
//

import SwiftUI

struct ScheduleCellView: View {
    var plant: Plant
    
    var body: some View {
        VStack {
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
            
            Text(plant.name)
            Text(plant.location)
                .foregroundColor(.secondary)
                .font(.caption)
            
        }
//        .padding()
//        .border(.blue)
    }
}

struct ScheduleCellView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCellView(plant: Plant(entity: Plant.entity(), insertInto: nil))
    }
}
