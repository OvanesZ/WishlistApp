//
//  FriendsCell.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI

struct FriendsCell: View {
    
    let friend: UserModel
    @State var uiImage = UIImage(named: "person")
    @State private var isLoadImage = false
//    @State private var url: URL?
    
    init(friend: UserModel) {
        self.friend = friend
    }
    
    var body: some View {
        
        
        HStack {
            
            Image(uiImage: uiImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay {
                    if isLoadImage {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(2)
                    }
                }
            
//            AsyncImage(url: url) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 60, height: 60)
//                    .scaledToFill()
//                    .clipShape(Circle())
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: 20, height: 20)
            
            
            
            Text(friend.email)
                .padding(.leading, 3)
                .lineLimit(2)
                .bold()
        }
        .onFirstAppear {
            isLoadImage = true
            
            StorageService.shared.downloadUserImage(id: friend.id) { result in
                switch result {
                case .success(let data):
                    isLoadImage = false
                    if let img = UIImage(data: data) {
                        self.uiImage = img
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
//        .onAppear {
////            isLoadingImage = true
//
//            StorageService.shared.downloadURLUserImage(id: friend.id) { result in
//                switch result {
//                case .success(let url):
////                    isLoadingImage = false
//                    if let url = url {
//                        self.url = url
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        
        
    }
    
}

extension Text {
    func boldItalic() -> Text {
        self.bold().italic()
    }
}

//struct FriendsCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsCell(friend: UserModel(id: "1", email: "test@test.com", displayName: "Test", phoneNumber: 0, address: "", userImageURLText: "https://i.klerk.ru/PeBvi-xi1wovZDomiEcqboxWA1GCQW2Ia1wBGU_KkyI/rs:fit/w:674/h:235/q:100/aHR0cHM6Ly93d3cu/a2xlcmsucnUvdWdj/L2Jsb2dQb3N0LzUw/MjU0Ny8xLnBuZw.webp", dateOfBirth: Date()))
//    }
//}
