//
//  SkeletonView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 19.01.2024.
//

import SwiftUI

class SkeletonViewModel: ObservableObject {
    @Published var offset_x: CGFloat = 0
}

struct SkeletonView: View {
    @StateObject var viewModel = SkeletonViewModel()

    
    var body: some View {
        let startGradient = Gradient.Stop(color: .indigo, location: 0.3)
        let endGradient = Gradient.Stop(color: .indigo, location: 0.7)
        let maskGradient = Gradient.Stop(color: .white.opacity(0.5), location: 0.5)
        
        let gradient = Gradient(stops: [startGradient, maskGradient, endGradient])
        
        let linearGradient = LinearGradient(gradient: gradient,
                                            startPoint: .leading,
                                            endPoint: .trailing)
        
        
        GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.indigo)
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.clear)
                            .background(linearGradient.cornerRadius(6).offset(x: viewModel.offset_x))
                            .cornerRadius(6)
                            .onAppear {
                                let baseAnimation = Animation.linear(duration: 1)
                                let repeated = baseAnimation.repeatForever(autoreverses: false)
                                viewModel.offset_x = -self.shimmerOffset(geometry.size.width - 50)
                                DispatchQueue.main.async {
                                    withAnimation(repeated) {
                                        viewModel.offset_x = self.shimmerOffset(geometry.size.width)
                                    }
                                }
                            }
                    }
                    .clipped()
        }
        
    }
    
    func shimmerOffset(_ width: CGFloat) -> CGFloat {
        width + CGFloat(2 * 20)
    }
}




#Preview {
    SkeletonView()
}
