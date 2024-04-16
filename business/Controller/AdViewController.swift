//
//  AdViewController.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 12/04/24.
//

import GoogleMobileAds

class AdViewController: UIViewController, GADFullScreenContentDelegate {
    var rewardedAd: GADRewardedAd?
    var interstitialAd: GADInterstitialAd?
    
    var handleReward: () -> Void = {}
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content with error: \(error.localizedDescription)")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AdMobService.loadRewardedAd(inAVC: self)
        AdMobService.loadInterstitialAd(inAVC: self)
    }
}
