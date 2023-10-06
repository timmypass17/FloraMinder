//
//  PlantImage.swift
//  PlantWateringApp
//
//  Created by Timmy Nguyen on 8/29/23.
//

import SwiftUI
import PhotosUI

struct EditableCircularPlantImage: View {
    @Binding var imageSelection: PhotosPickerItem?
    var imageState: ImageState
    
    var body: some View {
        CircularPlantImage(imageState: imageState)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $imageSelection, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
            }
    }
}

struct CircularPlantImage: View {
    let imageState: ImageState
    
    var body: some View {
        PlantImage(imageState: imageState)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .background {
                Circle().fill(.regularMaterial)
            }
    }
}

struct PlantImage: View {
    let imageState: ImageState
    
    var body: some View {
        switch imageState {
        case .success(let data):
            Image(uiImage: UIImage(data: data)!)
                .resizable().scaledToFill()
        case .loading(let progress):
            ProgressView()
        case .empty:
            Image(systemName: "camera.macro")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure(let error):
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct EditableCircularPlantImage_Previews: PreviewProvider {
    static var previews: some View {
        EditableCircularPlantImage(imageSelection: .constant(.none), imageState: .empty)
    }
}

