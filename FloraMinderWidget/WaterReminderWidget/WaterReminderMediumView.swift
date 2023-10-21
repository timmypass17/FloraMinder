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
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("FloraMinder")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("Today")
                        .foregroundColor(.secondary)
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
                
                Spacer()
                
                if plants.isEmpty {
                    Text("No water today")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .unredacted()
                    
                    Spacer()
                }
                
                Grid {
                    GridRow {
                        ForEach(plants.prefix(4), id: \.id) { plant in
                            ScheduleCellView(plant: plant)
                                .frame(width: geometry.size.width * 0.20)
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
