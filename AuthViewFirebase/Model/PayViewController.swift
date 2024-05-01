//
//  PayViewController.swift
//  Wishlist
//
//  Created by Ованес Захарян on 01.05.2024.
//

import UIKit

class PayViewController: UIViewController {
    
    private var backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    
    func addComponents() {
        backgroundImageView.image = UIImage(named: "bg_wishlist")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    
    lazy var titleTextName: UILabel = {
        let text = UILabel()
        text.text = "Вишлист - список пожеланий"
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 22)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    lazy var titleTextFullVersion: UILabel = {
        let text = UILabel()
        text.text = "Полная версия"
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.backgroundColor = UIColor(named: "payButton")
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTouch), for: .touchUpInside)
        
        return button
    }()
    
    lazy var titleTextDescription: UILabel = {
        let text = UILabel()
        text.text = "🎁 Добавляйте неограниченное количество подарков в Ваш список!"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 20)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    lazy var titleTextDescriptionTwo: UILabel = {
        let text = UILabel()
        text.text = "🔒 Бронируйте подарки друзьям и радуйте их! 🎉"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 20)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    
    
    override func viewDidLoad() {
        
        addComponents()
        
        view.addSubview(button)
        view.addSubview(titleTextName)
        view.addSubview(titleTextFullVersion)
        view.addSubview(titleTextDescription)
        view.addSubview(titleTextDescriptionTwo)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            titleTextName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            titleTextName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            titleTextName.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            
            titleTextFullVersion.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextFullVersion.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            
            titleTextDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            titleTextDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            titleTextDescription.topAnchor.constraint(equalTo: view.topAnchor, constant: 145),
            
            titleTextDescriptionTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            titleTextDescriptionTwo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            titleTextDescriptionTwo.topAnchor.constraint(equalTo: view.topAnchor, constant: 225),
        ])
        
    }
    
    @objc func payButtonTouch() {
        let _ = PayModel(vc: self) { res in
            switch res {
            case .succeeded:
                print("Оплата прошла успешно")
                UserManager.shared.updatePremiumStatus(userId: AuthService.shared.currentUser?.uid ?? "")
            case .failed:
                print("Возникла ошибка при оплате")
            case .cancelled:
                print("Отмена оплаты")
            }
        }
    }
    
}
