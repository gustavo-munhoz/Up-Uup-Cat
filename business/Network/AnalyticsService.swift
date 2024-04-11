//
//  AnalyticsService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 10/04/24.
//

import FirebaseAnalytics

class AnalyticsService {
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
