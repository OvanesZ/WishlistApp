//
//  PresentCellView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import SwiftUI
import Kingfisher

struct PresentCellView: View {
    
    // MARK: - properties
    
    let present: PresentModel
    @StateObject var viewModel = PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: "", ownerId: "", whoReserved: ""))
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - init()
    
    init(present: PresentModel) {
        self.present = present
    }
    
    
    
    var body: some View {
        
//        VStack {
//            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                .stroke(present.isReserved ? LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)), Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
//                .frame(width: 130, height: 130)
//                .overlay {
//                    
//                    KFImage(viewModel.url)
//                        .placeholder {
//                            ProgressView()
//                        }
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 124, height: 124)
//                        .clipShape(RoundedRectangle(cornerRadius: 27, style: .continuous))
//                    
//                }
//            
//            Text(present.name)
//                .font(.callout.bold())
//                .padding(.top, 3)
//                .foregroundStyle(colorScheme == .dark ? .white : .black)
//        }
//        .padding(.top, 4)
//        .task {
//            try? await self.viewModel.url = viewModel.getUrlPresentImage(presentId: present.id)
//        }
        
        
     
            
            VStack {
                Spacer()
                
                HStack {
                    Text(present.name)
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                
                    
                HStack {
                    Text("$450")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.bottom, -8)
                
                HStack {
                    Text(present.presentDescription)
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                        .padding(.leading, 8)

                    
                    
                    Spacer()
                    
                    Circle()
                        .scaledToFill()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(present.isReserved ? .red : .green)
                        .padding(.trailing, 10)
                        .padding(.bottom, 5)
                }
                .padding(.bottom, 5)
                    
            }
            .frame(width: 160, height: 210)
            
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray, lineWidth: 0.5)
                    .background(RoundedRectangle(cornerRadius: 7).fill(Color.white))
                    .shadow(color: .gray, radius: 3, x: 0, y: 5)
                    .frame(width: 160, height: 210)
                    .overlay(
                        VStack {
                            KFImage(viewModel.url)
                                .placeholder {
                                    ProgressView()
                                }
                                .resizable()
                                .frame(width: 140, height: 140)
                                .scaledToFill()
                                .padding()
                            
                            Spacer()
                        }
                        
                    )
            )
        .task {
            try? await self.viewModel.url = viewModel.getUrlPresentImage(presentId: present.id)
        }
        
        
        
        
    }
    
}
