//
//  BackgroundMusic.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import Foundation

enum BackgroundMusic: String, CaseIterable {
    case catNipDaze = "cat-nip-daze"
    case beachResort = "beach-resort"
    case birdWatching = "bird-watching"
    case feelinFresh = "feelin-fresh"
    case loadingScreen = "loading-screen"
    case saturdayMorning = "saturday-morning"
    case squeakyComputerChair = "squeaky-computer-chair"
    case treatTime = "treat-time"
    case wispyWhiskers = "wispy-whiskers"
}

extension BackgroundMusic {
    var formattedName: String {
        rawValue.replacingOccurrences(of: "-", with: " ").capitalized
    }
    
    var filename: String {
        rawValue + ".mp3"
    }
    
    func play() {
        AudioManager.shared.playBackgroundMusic(track: self)
    }
    
    func stop() {
        AudioManager.shared.stopBackgroundMusic()
    }
}
