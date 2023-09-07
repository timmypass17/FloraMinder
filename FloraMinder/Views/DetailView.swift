//
//  DetailView.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject var detailViewModel: DetailViewModel
    
    init(plant: Plant) {
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(plant: plant))
        
    }
    
    var body: some View {
        Form {
            Section("Plant") {
                if let imageFilePath = detailViewModel.plant.imageFilePath,
                    let image = UIImage(contentsOfFile: imageFilePath) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "leaf.circle.fill")
                        .frame(width: 100, height: 100)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Label("Plant Name", systemImage: "leaf")
                    Spacer()
                    Text(detailViewModel.plant.name)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Location", systemImage: "house")
                    Spacer()
                    Text(detailViewModel.plant.location)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Water Interval", systemImage: "drop")
                    Spacer()
                    Text("\(detailViewModel.plant.unit) \(detailViewModel.plant.interval.rawValue)s")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("Last Watered", systemImage: "clock")
                    Spacer()
                    Text("\(detailViewModel.plant.lastWatered.formatted(date: .abbreviated, time: .omitted))")
                        .foregroundColor(.secondary)
                }
            }
            
//            Section("History") {
//                Text("")
//            }
            
            // Section("Screen shots")
            // Section("AR shot")
        }
        .navigationTitle(detailViewModel.plant.name)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    detailViewModel.isPresentingEditPlantSheet = true
                }
            }
        }
        .sheet(isPresented: $detailViewModel.isPresentingEditPlantSheet) {
            AddEditPlantSheet(
                plant: detailViewModel.plant,
                isPresentingAddEditPlantSheet: $detailViewModel.isPresentingEditPlantSheet)
                .environment(\.managedObjectContext, context)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(plant: Plant(entity: Plant.entity(), insertInto: nil))
    }
}
