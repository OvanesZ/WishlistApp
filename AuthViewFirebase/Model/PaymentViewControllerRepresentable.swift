//
//  PaymentViewControllerRepresentable.swift
//  Wishlist
//
//  Created by Ованес Захарян on 01.05.2024.
//

import SwiftUI

struct PaymentViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = PayViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
