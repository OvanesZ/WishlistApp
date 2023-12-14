//
//  FriendPresentMainView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


struct FriendPresentsMainView: View {
    
    let present: PresentModel
    @State private var isShowPresentCell = false
    @State private var isLoadingImage = false
    @ObservedObject var friendHomeViewModel: FriendHomeViewModel
    @StateObject var viewModel = PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: ""))
    
    
    init(present: PresentModel, friendHomeViewModel: FriendHomeViewModel) {
        self.present = present
        self.friendHomeViewModel = friendHomeViewModel
    }
    
    var body: some View {
        

        VStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(present.isReserved ? LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 135, height: 135)
                .overlay {
                    ZStack {
                        VStack {
                            
                            Button {
                                isShowPresentCell.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .overlay {
                                        Image(uiImage: viewModel.uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                        
                                        if isLoadingImage {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                                .scaleEffect(2)
                                        }
                                        
                                    }
                                    .opacity(50)
                                    .frame(width: 130, height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            }
                        }
                    }
                    .sheet(isPresented: $isShowPresentCell) {
                        FriendPresentView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(friend: friendHomeViewModel.friend))
                        
                    }
                }
            Text(present.name)
                .font(.callout.bold())
                .padding(.top, 3)
        }
        .onFirstAppear {
            isLoadingImage = true
            
            StorageService.shared.downloadPresentImage(id: present.id) { result in
                switch result {
                case .success(let data):
                    isLoadingImage = false
                    if let img = UIImage(data: data) {
                        self.viewModel.uiImage = img
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
