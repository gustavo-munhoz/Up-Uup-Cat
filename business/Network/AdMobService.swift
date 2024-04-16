//
//  AdMobService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 11/04/24.
//

import Foundation
import GoogleMobileAds

class AdMobService {
    
    // MARK: - Rewarded Ads
    
    static func loadRewardedAd(inAVC vc: AdViewController) {
        GADRewardedAd.load(withAdUnitID: Secrets.rewardAdId, request: GADRequest()) { [weak vc] (ad, error) in
            guard let vc = vc else { return }
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            vc.rewardedAd = ad
            vc.rewardedAd?.fullScreenContentDelegate = vc
        }
    }
    
    static func showRewardedAd(atAVC vc: AdViewController) {
        if let ad = vc.rewardedAd {
            ad.present(fromRootViewController: vc) {
                vc.handleReward()
            }
            
        } else {
            print("Ad was not ready.")
        }
    }
    
    // MARK: - Interstitial Ads
    
    static func loadInterstitialAd(inAVC vc: AdViewController) {
        GADInterstitialAd.load(withAdUnitID: Secrets.interstitialAdId, request: GADRequest()) { [weak vc] (ad, error) in
            guard let vc = vc else { return }
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            vc.interstitialAd = ad
            vc.interstitialAd?.fullScreenContentDelegate = vc
        }
    }
    
    static func showInterstitialAd(atAVC vc: AdViewController) {
        if let ad = vc.interstitialAd {
            ad.present(fromRootViewController: vc)
            
        } else {
            print("Ad was not ready.")
        }
    }
}
