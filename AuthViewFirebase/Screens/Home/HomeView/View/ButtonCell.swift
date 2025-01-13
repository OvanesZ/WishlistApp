//
//  ButtonCell.swift
//  Wishlist
//
//  Created by Ованес Захарян on 13.01.2025.
//

import SwiftUI

struct ButtonCell: View {
    
    var text: String
    var textSystemName: String
    
   
    
    var body: some View {
        
        
       // #ECE6F0
        // 65558F
            
        
        
        Button(action: {
            
        }, label: {
            
            VStack {
                Image(systemName: textSystemName)
                    .foregroundStyle(Color("textColor"))
                    .font(.title)
                    .bold()
                
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.black)
                    .padding(.bottom, -20)
                    .padding(.top, 3)
                    
            }
            .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color("fillColor"))
                .frame(width: 110, height: 110)
                .shadow(color: .gray, radius: 6, y: 6)
            )
        })
        
        
        
        
    }
}

//#Preview {
//    ButtonCell(text: "", textSystemName: "")
//}
