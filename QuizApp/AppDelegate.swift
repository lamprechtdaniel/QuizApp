//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var storedUserName: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "AppQuiz.username")
        }
        get {
            UserDefaults.standard.string(forKey: "AppQuiz.username")
        }
    }
    static let backendHost = URL(string: "http://127.0.0.1:3000")
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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


}

