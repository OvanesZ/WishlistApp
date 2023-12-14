//
//  PhotoPicker.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 16.09.2023.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
}

//struct PhotoPicker: View {
//    
//    @StateObject private var viewModel = PhotoPickerViewModel()
//    
//    var body: some View {
//        
//        VStack(spacing: 40) {
//            
//            
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            
//            if let image = viewModel.selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 200, height: 200)
//                    .cornerRadius(10)
//            }
//            
//            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
//                Text("Open PhotoPicker")
//                    .foregroundColor(.red)
//            }
//            
//        }
//    }
//}
//
//struct PhotoPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoPicker()
//    }
//}
