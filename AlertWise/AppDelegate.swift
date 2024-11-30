//
//  AppDelegate.swift
//  IOT Project
//
//  Created by William Chrisandy on 17/11/23.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let initDone = UserDefaults.standard.bool(forKey: AppConstants.isInitializationDoneKey)
        if initDone == false {
            initApplication()
        }
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func initApplication() {
        UserDefaults.standard.setValue(true, forKey: AppConstants.protectedKey)
        UserDefaults.standard.setValue(true, forKey: AppConstants.isInitializationDoneKey)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "Failed")")
        
        if let fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: AppConstants.fcmRegistrationToken)
            let isProtected = UserDefaults.standard.bool(forKey: AppConstants.protectedKey)
            if isProtected == true {
                Messaging.messaging().subscribe(toTopic: AppConstants.notificationTopic) {
                    error in
                    if let error {
                        print("Error subscribing to \"\(AppConstants.notificationTopic)\" topic: \(error)")
                    }
                    print("Subscribed to \"\(AppConstants.notificationTopic)\" topic")
                }
            }
            else {
                Messaging.messaging().unsubscribe(fromTopic: AppConstants.notificationTopic) { error in
                    if let error {
                        print("Error unsubscribing to \"\(AppConstants.notificationTopic)\" topic: \(error)")
                    }
                    print("Unsubscribed to \"\(AppConstants.notificationTopic)\" topic")
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive User info \(userInfo)")
        
        // Always call the completion handler when done.
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification User info \(userInfo)")
        
        let context = persistentContainer.viewContext
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MM yyyy"
        
        let history = HistoryModel(context: context)
        history.actionType = 3
        history.actionDate = dateFormatter.date(from: userInfo["time"] as? String ?? "") ?? Date()
        
        context.insert(history)
        saveContext()
        
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent User info \(notification.request.content.userInfo)")
        // Don't alert the user for other types.
        //completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataHistory")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //tambahan
    
}
