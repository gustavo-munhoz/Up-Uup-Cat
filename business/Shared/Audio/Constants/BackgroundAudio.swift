//
//  AudioConstants.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import Foundation

enum BackgroundAudio: String {
    case catNipDaze = "cat-nip-daze"
    case beachResort = "beach-resort"
    case birdWatching = "bird-watching"
    case feelinFresh = "feeling-fresh"
    case loadingScreen = "loading-screen"
    case saturdayMorning = "saturday-morning"
    case squeakyComputerChair = "squeaky-computer-chair"
    case treatTime = "treat-time"
    case wispyWhiskers = "wispy-whiskers"
}

extension BackgroundAudio {
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
