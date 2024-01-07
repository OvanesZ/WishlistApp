//
//  PresentCellView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import SwiftUI
import Kingfisher

struct PresentCellView: View {
    
    let present: PresentModel
    @State var isShowPresentCell = false
    @State private var isLoadingImage = false
    @GestureState private var isLongPressed = false
    @StateObject var viewModel = PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: ""))
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - init()
    init(present: PresentModel) {
        self.present = present
    }
    
    var body: some View {
        
            VStack {
                
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(present.isReserved ? LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                    .frame(width: 130, height: 130)
                    .overlay {
                        KFImage(viewModel.url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 124, height: 124)
//                            .overlay(alignment: .bottomLeading, content: {
//                                Text(present.name)
//                                    .font(.custom("NeutralFace", fixedSize: 14).bold())
//                                    .padding(.leading, 5)
//                                    .padding(.bottom, 6)
//                                    .foregroundStyle(.white)
//                                
//                            })
                            .clipShape(RoundedRectangle(cornerRadius: 27, style: .continuous))
                    }
                
                Text(present.name)
                    .font(.callout.bold())
                    .padding(.top, 3)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                
            }
        
        .onAppear {
            
            StorageService.shared.downloadURLPresentImage(id: present.id) { result in
                switch result {
                case .success(let url):
                    if let url = url {
                        self.viewModel.url = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        
        
        
    }
    
}
