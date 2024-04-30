//
//  LaunchTransitionViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class LaunchTransitionViewController: UIViewController {
    
    private var launchTransitionView = LaunchTransitionView()
    
    override func loadView() {
        view = launchTransitionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestTrackingAuthorization()
        
        SoundEffect.snore.playIfAllowed()
        
        launchTransitionView.startAnimation {
            UserPreferences.shared.selectedBackgroundMusic.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.pushViewController(MenuViewController(), animated: true)
            }
        }
    }
    
    func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking Authorized")
                        
                case .denied:
                    print("Tracking Denied")
                        
                case .notDetermined:
                    print("Tracking Not Determined")
                        
                case .restricted:
                    print("Tracking Restricted")
                        
                @unknown default:
                    print("Tracking Unknown")
                }
            }
        } else {
            print(ASIdentifierManager.shared().advertisingIdentifier)
        }
    }
}
