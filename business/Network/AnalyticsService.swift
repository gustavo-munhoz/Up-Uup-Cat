//
//  AnalyticsService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 10/04/24.
//

import FirebaseAnalytics

class AnalyticsService {
    private init() {}
    
    static func logEventShopButtonPressed() {
        Analytics.logEvent("shop_pressed", parameters: [:])
    }
    
    static func logEventRankingButtonPressed() {
        Analytics.logEvent("ranking_pressed", parameters: [:])
    }
    
    static func logEventTutorialButtonPressed() {
        Analytics.logEvent("tutorial_pressed", parameters: [:])
    }
    
    static func logEventGameStarted() {
        Analytics.logEvent(AnalyticsEventLevelStart, parameters: [:])
    }
    
    static func logEventGamePaused() {
        Analytics.logEvent("game_paused", parameters: [:])
    }
    
    static func logEventGameOver() {
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [:])
    }
    
    static func logEventPressedRestart() {
        Analytics.logEvent("pressed_restart", parameters: [:])
    }
    
    static func logEventPostScore(_ score: Int) {
        Analytics.logEvent(AnalyticsEventPostScore, parameters: [
            AnalyticsParameterScore: score
        ])
    }
    
    static func logEventEarnVirtualCurrency(type: Collectible, _ value: Int) {
        Analytics.logEvent(AnalyticsEventEarnVirtualCurrency, parameters: [
            AnalyticsParameterVirtualCurrencyName: type == .nigiri ? "Nigiris" : "Catnips",
            AnalyticsParameterValue: value
        ])
    }
}
