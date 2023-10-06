//
//  WaterReminderSmallView.swift
//  FloraMinderWidgetExtension
//
//  Created by Timmy Nguyen on 10/4/23.
//

import SwiftUI
import WidgetKit

struct WaterReminderSmallView: View {
    var plants: [Plant]
    
    var description: String {
        plants.isEmpty ? "No Tasks" : "Water \(plants.count) plants"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("FloraMinder")
                .fontWeight(.semibold)
                .foregroundColor(.green)

            HStack {
                Text("Today")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .unredacted()

                Spacer()
                
            }
//            Text(description)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .fontWeight(.semibold)
//
            Spacer()
            
            
            if !plants.isEmpty {
                Image(systemName: "camera.macro")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 75, height: 75)
                    .background {
                        Circle().fill(.secondary).opacity(0.25)
                    }
                    .unredacted()
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(plants.count)")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(8)
                            .background {
                                Circle().fill(.green)
                            }
                    }
                    .frame(maxWidth: .infinity)
            } else {
                Text("No water today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
//                    .fontWeight(.semibold)
                
            }
            
            Spacer()
            
//            Text(description)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .fontWeight(.semibold)
//                .font(.caption)
            
        }
        .padding()
    }
}

struct WaterReminderSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WaterReminderSmallView(plants: [])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
