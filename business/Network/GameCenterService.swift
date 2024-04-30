//
//  GameCenterService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 16/04/24.
//

import Foundation
import GameKit
import FirebaseAuth

/// A service responsible for managing Game Center functionalities such as player authentication,
/// rewarding achievements, and controlling the access point's visibility.
///
/// This class provides a centralized way to interact with Game Center functionalities and
/// manage the Game Center experience for the user.
class GameCenterService {
    
    /// The shared singleton instance of `GameService`.
    static let shared = GameCenterService()
    
    /// Represents the local player instance from GameKit, which will be used for authentication.
    let player = GKLocalPlayer.local
    
    func authenticateAndSyncData(completion: @escaping (_ error: String?) -> Void) {
        player.authenticateHandler = { [weak self] viewController, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let vc = viewController {
                    self.presentGameCenterAuth(vc)
                    return
                } else if let error = error {
                    completion("Game Center Authentication Error: \(error.localizedDescription)")
                    return
                } else if self.player.isAuthenticated {
                    self.syncDataWithFirestore(completion: completion)
                    UserPreferences.shared.playerId = self.player.gamePlayerID
                    
                } else {
                    completion("Game Center Authentication failed")
                }
            }
        }
    }
    
    private func presentGameCenterAuth(_ viewController: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        let rootViewController = windowScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController

        rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    private func authenticateWithFirebase(completion: @escaping (_ error: String?) -> Void) {
        GameCenterAuthProvider.getCredential { credential, error in
            guard let credential = credential, error == nil else {
                print("Error obtaining Game Center credential: \(error?.localizedDescription ?? "Unknown error")")
                completion(error?.localizedDescription ?? "Failed to get Game Center credential")
                return
            }
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase authentication error: \(error.localizedDescription)")
                    completion(error.localizedDescription)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func syncDataWithFirestore(completion: @escaping (_ error: String?) -> Void) {
        FirestoreService.shared.loadSettings(for: player.gamePlayerID) { (remoteSettings: AppSettings?) in
            guard let localSettings = UserPreferences.shared.loadLocalSettings() else {
                completion("Local settings not found")
                return
            }

            if let remoteSettings = remoteSettings,
               let localLastUpdated = localSettings.lastUpdated,
               let remoteLastUpdated = remoteSettings.lastUpdated,
               remoteLastUpdated > localLastUpdated {
                // Remote settings are newer
                UserPreferences.shared.updateSettings(with: remoteSettings)
                print("Remote settings are newer, replacing local settings.")
            } else {
                // Local settings are newer or no valid remote settings
                FirestoreService.shared.saveSettings(data: localSettings, for: self.player.gamePlayerID) { _ in }
                
                print("Local settings are newer or no valid remote settings, saving to Firestore.")
            }
            completion(nil)
        }
    }
    
    func presentGameCenter(from viewController: UIViewController) {
        guard player.isAuthenticated else {
            print("Player is not authenticated")
            return
        }
        
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = viewController as? GKGameCenterControllerDelegate
        
        viewController.present(gcViewController, animated: true, completion: nil)
    }
    
    /// Rewards an achievement to the player based on the provided identifier.
    ///
    /// The achievement will be marked as 100% complete and will display a completion banner.
    ///
    /// - Parameter identifier: The unique identifier of the achievement to be rewarded.
    func rewardAchievement(_ identifier: String) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement])
    }
    
    func reportAchievement(identifier: String, progress: Double) {
        guard progress > 0 else { return }
        
        let achievement = GKAchievement(identifier: identifier)
        
        GKAchievement.loadAchievements { (achievements, error) in
            guard error == nil else {
                print("Erro ao carregar achievements:", error!)
                return
            }
            
            let currentAchievement = achievements?.first { $0.identifier == identifier }
            let currentProgress = currentAchievement?.percentComplete ?? 0.0
            
            let newProgress = currentProgress + progress
            achievement.percentComplete = newProgress
            achievement.showsCompletionBanner = true
            
            if newProgress >= 99 && newProgress < 100.0 {
                achievement.percentComplete = 100.0
            }
            
            GKAchievement.report([achievement]) { error in
                if let error = error {
                    print("Erro ao reportar achievement:", error)
                }
            }
        }
    }
    
    /// Resets all the achievements for the player.
    ///
    /// This function will reset all achievements back to their initial, unearned state.
    func resetAchievements() {
        GKAchievement.resetAchievements()
    }
    
    func showAchievements() {
        GKAccessPoint.shared.trigger(state: .achievements) {
            print("Acessou os achievements")
        }
    }
    
    func submitScore(_ score: Int, ids: [String], completion: @escaping () -> Void?) {
        Task {
            try? await GKLeaderboard.submitScore(
                score,
                context: 0,
                player: player,
                leaderboardIDs: ids
            )
            
            completion()
        }
    }
}
