//
//  PlantParts.swift
//  FloraMinder
//
//  Created by Timmy Nguyen on 10/18/23.
//

import Foundation

// Wrapper class for Plant
struct PlantParts {
    var name: String
    var location: String
    var lastWateredDate: Date
    var interval: WaterTimeInterval
    var unit: Int
    var imageState: ImageState
}
