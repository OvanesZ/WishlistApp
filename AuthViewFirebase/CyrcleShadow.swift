//
//  CyrcleShadow.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI



struct CircleShadow: ViewModifier {
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
            .overlay { Circle().stroke(.white, lineWidth: 2) }
            .background(Circle()
                            .fill(Color.black)
                            .shadow(color: shadowColor, radius: shadowRadius))
    }
}


struct RectangleShadow: ViewModifier {
    let shadowColor: Color
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(Rectangle())
            .overlay { Rectangle().stroke(.white, lineWidth: 2) }
            .background(Rectangle()
                            .fill(Color.black)
                            .shadow(color: shadowColor, radius: shadowRadius))
    }
}

struct CircleWithoutShadow: ViewModifier {
//    let shadowColor: Color
//    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(Circle())
//            .overlay { Circle().stroke(.white, lineWidth: 2) }
//            .background(Circle()
//                            .fill(Color.black)
//                            .shadow(color: shadowColor, radius: shadowRadius))
    }
}
