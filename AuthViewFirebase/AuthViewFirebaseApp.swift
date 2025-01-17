//
//  AuthViewFirebaseApp.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 19.08.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

//@main
//struct AuthViewFirebaseApp: App {
//    
//    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
//    
//    var body: some Scene {
//        WindowGroup {
//            
//            SplashScreenView()
//            
////            if let user = AuthService.shared.currentUser {
////                let viewModel = MainTabBarViewModel(user: user)
////                MainTabBar(viewModel: viewModel)
////            } else {
////                AuthView()
////            }
//            
//            
//        }
//    }
//    
//    class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
//        let gcmMessageIDKey = "gcm.message_id"
//        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            
//           
//            
//            FirebaseApp.configure()
//            print("App Delegate Did lainching")
//            Messaging.messaging().delegate = self
//            if #available(iOS 10.0, *) {
//                      // For iOS 10 display notification (sent via APNS)
//                      UNUserNotificationCenter.current().delegate = self
//
//                      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//                      UNUserNotificationCenter.current().requestAuthorization(
//                        options: authOptions,
//                        completionHandler: {_, _ in })
//                    } else {
//                      let settings: UIUserNotificationSettings =
//                      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                      application.registerUserNotificationSettings(settings)
//                    }
//
//                    application.registerForRemoteNotifications()
//            
//            
//            
//            return true
//        }
//        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                             fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//              if let messageID = userInfo[gcmMessageIDKey] {
//                print("Message ID: \(messageID)")
//              }
//
//              print(userInfo)
//
//              completionHandler(UIBackgroundFetchResult.newData)
//            }
//        
//        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//              let deviceToken:[String: String] = ["token": fcmToken ?? ""]
//                print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
//            }
//        
//        func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                      willPresent notification: UNNotification,
//            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            let userInfo = notification.request.content.userInfo
//
//            if let messageID = userInfo[gcmMessageIDKey] {
//                print("Message ID: \(messageID)")
//            }
//
//            print(userInfo)
//
//            // Change this to your preferred presentation option
//            completionHandler([[.banner, .badge, .sound]])
//          }
//
//            func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//            }
//
//            func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//            }
//
//          func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                      didReceive response: UNNotificationResponse,
//                                      withCompletionHandler completionHandler: @escaping () -> Void) {
//            let userInfo = response.notification.request.content.userInfo
//
//            if let messageID = userInfo[gcmMessageIDKey] {
//              print("Message ID from userNotificationCenter didReceive: \(messageID)")
//            }
//
//            print(userInfo)
//
//            completionHandler()
//          }
//        
//    }
//    
//    
//    
//}






    
    
    
class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        print("App Delegate Did lainching")
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { isOn, _ in
            print(isOn)
            guard isOn else { return }
        }
        
        application.registerForRemoteNotifications()
        
        
        return true
    }
}


extension AppDelegate: MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("Token = \(token)")
        }
        setBadge(count: 0)
    }
    
    
    // Функция для установки количества бейджей на иконке. Можно вызывать откуда угодно. В данный момент всегда обнуляю.
    func setBadge(count: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { granted, error in
            if let error = error {
                print("Error requesting \(error.localizedDescription)")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().setBadgeCount(count, withCompletionHandler: nil)
                }
            } else {
                print("Badge auth denied")
            }
        }
    }
    
    
}



@main
struct AuthViewFirebaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            SplashScreenView()
                .preferredColorScheme(.light) // Всегда светлая тема
            
        }
    }
}
