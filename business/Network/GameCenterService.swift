//
//  GameCenterService.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 16/04/24.
//

import Foundation
import GameKit

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
    
    func authenticate(completion: @escaping (_ error: String?) -> Void) {
        player.authenticateHandler = { viewController, error in
            DispatchQueue.main.async {
                if let vc = viewController {
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                    let rootViewController = windowScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
                    
                    rootViewController?.present(vc, animated: true, completion: nil)
                    return
                } else if let error = error {
                    // Handle the error appropriately
                    print("Game Center Authentication Error: \(error.localizedDescription)")
                    completion(error.localizedDescription)
                } else if self.player.isAuthenticated {
                    // Player is authenticated
                    print("Player is authenticated with Game Center")
                    completion(nil)
                } else {
                    // Authentication failed with no error, handle appropriately
                    completion("Game Center Authentication failed")
                }
            }
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
