//
//  PayModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 30.04.2024.
//

import TinkoffASDKUI
import TinkoffASDKCore
import UIKit

class PayModel {
    
    var vc: UIViewController
    var completion: (PayResult) -> ()
    
    let credential = AcquiringSdkCredential(
        terminalKey: "1714235584463",
        publicKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv5yse9ka3ZQE0feuGtemYv3IqOlLck8zHUM7lTr0za6lXTszRSXfUO7jMb+L5C7e2QNFs+7sIX2OQJ6a+HG8kr+jwJ4tS3cVsWtd9NXpsU40PE4MeNr5RqiNXjcDxA+L4OsEm/BlyFOEOh2epGyYUd5/iO3OiQFRNicomT2saQYAeqIwuELPs1XpLk9HLx5qPbm8fRrQhjeUD5TLO8b+4yCnObe8vy/BMUwBfq+ieWADIjwWCMp2KTpMGLz48qnaD9kdrYJ0iyHqzb2mkDhdIzkim24A3lWoYitJCBrrB2xM05sm9+OdCI1f7nPNJbl5URHobSwR94IRGT7CJcUjvwIDAQAB"
    )

    

    let uiSDKConfiguration = UISDKConfiguration()

    
    init(vc: UIViewController, completion: @escaping (PayResult) -> ()) {
        
        self.vc = vc
        self.completion = completion
        
        let coreSDKConfiguration = AcquiringSdkConfiguration(
            credential: credential,
            server: .prod // Используемое окружение
        )
        
        let orderOptions = OrderOptions(
            /// Идентификатор заказа в системе продавца
            orderId: UUID().uuidString,
            // Полная сумма заказа в копейках
            amount: 100,
            // Краткое описание заказа
            description: "DESCRIPTION",
            // Данные чека
            receipt: nil,
            // Данные маркетплейса. Используется для разбивки платежа по партнерам
            shops: nil,
            // Чеки для каждого объекта в `shops`.
            // В каждом чеке необходимо указывать `Receipt.shopCode` == `Shop.shopCode`
            receipts: nil,
            // Сохранить платеж в качестве родительского
            savingAsParentPayment: false
        )

        let customerOptions = CustomerOptions(
            // Идентификатор покупателя в системе продавца.
            // С помощью него можно привязать карту покупателя к терминалу после успешного платежа
            customerKey: AuthService.shared.currentUser?.uid ?? "",
            // Email покупателя
            email: AuthService.shared.currentUser?.email
        )

        // Используется для редиректа в приложение после успешного или неуспешного совершения оплаты с помощью `TinkoffPay`
        // В иных сценариях передавать эти данные нет необходимости
        let paymentCallbackURL = PaymentCallbackURL(
            successURL: "SUCCESS_URL",
            failureURL: "FAIL_URL"
        )
        

        let paymentOptions: PaymentOptions = .init(orderOptions: orderOptions, customerOptions: customerOptions, paymentCallbackURL: paymentCallbackURL)
        
        let paymentFlow: PaymentFlow = .full(paymentOptions: paymentOptions)
        
        let config: MainFormUIConfiguration = .init(orderDescription: "Оплата за доступ к полной версии приложения")
        
        do {
            let sdk = try AcquiringUISDK(
                coreSDKConfiguration: coreSDKConfiguration,
                uiSDKConfiguration: uiSDKConfiguration
            )
            
            sdk.presentMainForm(on: vc, paymentFlow: paymentFlow, configuration: config) { res in
                switch res {
                case .succeeded(let success):
                    print(success)
                    completion(.succeeded)
                case .failed(let error):
                    print(error.localizedDescription)
                    completion(.failed)
                case .cancelled(let info):
                    print(info ?? "")
                    completion(.cancelled)
                }
            }
            
        } catch {
            // Ошибка может возникнуть при некорректном параметре `publicKey`
            assertionFailure("\(error)")
        }
    }

    
}

enum PayResult {
    case succeeded, failed, cancelled
}
