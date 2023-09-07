////
////  ScheduleView.swift
////  PlantWateringApp
////
////  Created by Timmy Nguyen on 8/29/23.
////
//
//import SwiftUI
//
//struct ScheduleView: View {
////    let sampleGardens: [Garden] = Garden.sampleGardens
//        
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(sampleGardens) { garden in
//                    Section(header: Text(garden.name)) {
//                        ForEach(garden.plants) { plant in
//                            PlantCellView(plant: plant)
//                                .padding(.vertical, 5)
//                        }
//                    }
//                    
//                }
//            }
//            .listStyle(.plain)
//            .navigationTitle("My Plants")
//            .toolbar {
//                ToolbarItem {
//                    Button(action: {}) {
//                        Label("Add Plant", systemImage: "plus")
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}
