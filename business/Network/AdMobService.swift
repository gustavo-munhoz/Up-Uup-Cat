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
    
    static func loadRewardedAd(inAVC vc: AdViewController) async {
        do {
            let ad = try await GADRewardedAd.load(
                withAdUnitID: Secrets.rewardAdId,
                request: GADRequest()
            )
            DispatchQueue.main.async {
                vc.rewardedAd = ad
                vc.rewardedAd?.fullScreenContentDelegate = vc
            }
        } catch {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
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
    
    static func loadInterstitialAd(inAVC vc: AdViewController) async {
        do {
            let ad = try await GADInterstitialAd.load(
                withAdUnitID: Secrets.interstitialAdId,
                request: GADRequest()
            )
            DispatchQueue.main.async {
                vc.interstitialAd = ad
                vc.interstitialAd?.fullScreenContentDelegate = vc
            }
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    static func showInterstitialAd(atAVC vc: AdViewController) {
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKeys.areAdsRemoved) else { return }
        
        if let ad = vc.interstitialAd {
            ad.present(fromRootViewController: vc)
            
        } else {
            print("Ad was not ready.")
        }
    }
    
    // MARK: - Banner Ads
    
    static func loadBannerAd(inAVC vc: AdViewController) {
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKeys.areAdsRemoved) else { return }
        
        vc.bannerView?.adUnitID = Secrets.bannerAdId
        vc.bannerView?.rootViewController = vc
        vc.bannerView?.load(GADRequest())
    }
}
