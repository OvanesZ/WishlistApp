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
