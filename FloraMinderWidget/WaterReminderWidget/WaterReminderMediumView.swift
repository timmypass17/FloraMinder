//
//  WaterReminderMediumView.swift
//  FloraMinderWidgetExtension
//
//  Created by Timmy Nguyen on 10/4/23.
//

import SwiftUI
import WidgetKit

struct WaterReminderMediumView: View {
    var plants: [Plant]
    
    var description: String {
        plants.isEmpty ? "No Tasks" : "Water \(plants.count) plants"
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible(minimum: 100), spacing: 16),
        ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("FloraMinder")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("Today")
                        .foregroundColor(.secondary)
//                        .font(.caption)
                        .fontWeight(.semibold)
                        .unredacted()

                    Spacer()
                    
                    if plants.count - 4 > 0 {
                        Text("+\(plants.count - 4) More")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                    }
                }
                
                Grid {
                    GridRow {
                        ForEach(plants.prefix(4), id: \.name) { plant in
                            ScheduleCellView(plant: plant)
                                .frame(width: geometry.size.width * 0.20)
//                                .border(.blue)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct WaterReminderMediumView_Previews: PreviewProvider {
    static var previews: some View {
        WaterReminderMediumView(plants: [])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
