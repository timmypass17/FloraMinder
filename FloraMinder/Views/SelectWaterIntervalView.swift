//
//  WaterIntervalView.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI
import Combine

struct SelectWaterIntervalView: View {
    @Environment(\.managedObjectContext) var context
    @Binding var waterTimeInterval: WaterTimeInterval
    @Binding var unit: Int
    
    var body: some View {
        Form {
            Section("Interval") {
                Picker("Water Every", selection: $waterTimeInterval) {
                    ForEach(WaterTimeInterval.allCases) { interval in
                        Text(interval.rawValue.capitalized)
                    }
                }
            }
            Section("Unit") {
                Picker("Unit", selection: $unit) {
                    ForEach(1...365, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.wheel)
            }
        }
    }
}

//struct WaterIntervalView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectWaterIntervalView(plant: Plant(entity: Plant().entity, insertInto: nil))
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
