//
//  AppDelegate.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 19/03/24.
//

import UIKit

import Firebase
import FirebaseCore

import FacebookCore
import FirebaseAnalytics

import AppTrackingTransparency
import AdSupport

import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "eb86b528a4b2a025260c549401222408" ]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

        
        GameManager.shared.loadStats()
        AudioManager.shared.loadUserAudioPreferences()
        
        AudioManager.shared.loadSoundEffects(
            effects: [.snore, .cucumberMove, .surprise, .pop]
        )
        
        GameCenterService.shared.authenticateAndSyncData { errorDescription in
            DispatchQueue.main.async {
                if let error = errorDescription {
                    print("Game Center Sync Error: \(error)")
                } else {
                    print("Game Center Sync: Synchronization successful")
                }
            }
        }
        
        let startViewController = LaunchTransitionViewController()
        
        let navigationController = UINavigationController(rootViewController: startViewController)
        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        AudioManager.shared.pauseBackgroundMusic()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AudioManager.shared.resumeBackgroundMusic()
    }
}

