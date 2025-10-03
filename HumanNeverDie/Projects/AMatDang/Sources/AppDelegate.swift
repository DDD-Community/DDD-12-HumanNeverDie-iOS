import UIKit
import UserNotifications

import Shared

import FirebaseCore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    configureFirebase()
    configureFirebaseMessaging()
    configurePushNotification()
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
}

// MARK: - Remote Notifications

extension AppDelegate {
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register for remote notifications: \(error.localizedDescription)")
  }
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    completionHandler(.newData)
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .badge, .sound])
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    print(response)
    completionHandler()
  }
}

// MARK: - MessagingDelegate

extension AppDelegate: @preconcurrency MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let fcmToken = fcmToken else { return }
    print("FCM registration token: \(fcmToken)")
  }
}

// MARK: - Private Methods
private extension AppDelegate {
  func configureFirebase() {
    FirebaseApp.configure()
  }
  
  func configureFirebaseMessaging() {
    Messaging.messaging().delegate = self
  }
  
  func configurePushNotification() {
    UNUserNotificationCenter.current().delegate = self
    
    Task { @MainActor in
      let authorizationStatus = await UNUserNotificationCenter.current().authorizationStatus()
      
      if authorizationStatus == .notDetermined {
        try await UNUserNotificationCenter.current().requestAuthorization(
          options: [.alert, .badge, .sound]
        )
      }
      
      await MainActor.run {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}
