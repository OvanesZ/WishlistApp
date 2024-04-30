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
    
    lazy var textLabel: UILabel = {
        let title = UILabel()
        title.text = "Вишлист - список пожеланий"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        return title
    }()
    
    lazy var textLabel1: UILabel = {
        let title = UILabel(frame: CGRect(x: 25, y: 125, width: 350, height: 50))
        title.text = "Преимущества полной версии:"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        return title
    }()
    
    lazy var textLabel2: UILabel = {
        let title = UILabel(frame: CGRect(x: 25, y: 175, width: 350, height: 50))
        title.text = "Добавляйте бесконечное количество пожеланий в свой список"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
//        title.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        return title
    }()
    
    lazy var textLabel3: UILabel = {
        let title = UILabel(frame: CGRect(x: 25, y: 225, width: 350, height: 50))
        title.text = "Бронируйте неограниченное количество подарков друзьям"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
//        title.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        return title
    }()
    
    override func viewDidLoad() {
        
        view.addSubview(button)
        view.addSubview(textLabel)
        view.addSubview(textLabel1)
        view.addSubview(textLabel2)
        view.addSubview(textLabel3)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            
            textLabel1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            textLabel1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            textLabel1.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            
            textLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            textLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            textLabel2.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            
            textLabel3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            textLabel3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            textLabel3.topAnchor.constraint(equalTo: view.topAnchor, constant: 45)
        
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
