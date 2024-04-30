//
//  PayViewController.swift
//  Wishlist
//
//  Created by Ованес Захарян on 01.05.2024.
//

import UIKit

class PayViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTouch), for: .touchUpInside)
        
        return button
    }()
    
//    lazy var title: UILabel = {
//        let title = UILabel()
//        
//        return title
//    }()
    
    
    override func viewDidLoad() {
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        
        ])
        
    }
    
    @objc func payButtonTouch() {
        let _ = PayModel(vc: self) { res in
            switch res {
            case .succeeded:
                print("Оплата прошла успешно")
            case .failed:
                print("Возникла ошибка при оплате")
            case .cancelled:
                print("Отмена оплаты")
            }
        }
    }
    
}
