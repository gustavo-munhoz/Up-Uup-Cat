//
//  AudioManager.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 18/04/24.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()

    var backgroundMusicVolume: Float = UserPreferences.shared.backgroundMusicVolume {
        didSet {
            UserPreferences.shared.backgroundMusicVolume = backgroundMusicVolume
            backgroundMusicPlayer?.volume = backgroundMusicVolume
        }
    }
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:]

    private init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    func loadUserAudioPreferences() {
        backgroundMusicVolume = UserPreferences.shared.backgroundMusicVolume
        loadBackgroundMusic(track: UserPreferences.shared.selectedBackgroundMusic)
    }

    func loadBackgroundMusic(track: BackgroundMusic) {
        guard let bundlePath = Bundle.main.path(
            forResource: track.filename,
            ofType: "mp3",
            inDirectory: "Media/BackgroundMusic"
        ) else {
            print("Background music file not found.")
            return
        }
        do {
            let url = URL(fileURLWithPath: bundlePath)
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay()
        } catch {
            print("Could not load background music file: \(error)")
        }
    }
    
    func loadSoundEffects(effects: [SoundEffect]) {
        for effect in effects {
            guard let bundlePath = Bundle.main.path(
                forResource: effect.filename,
                ofType: nil,
                inDirectory: "Media/SoundEffects"
            ) else {
                print("Sound effect file \(effect.filename) not found.")
                continue
            }
            do {
                let url = URL(fileURLWithPath: bundlePath)
                let soundPlayer = try AVAudioPlayer(contentsOf: url)
                soundPlayer.prepareToPlay()
                soundEffectPlayers[effect.filename] = soundPlayer
            } catch {
                print("Could not load sound effect file \(effect.filename): \(error)")
            }
        }
    }

    
    func playBackgroundMusic(track: BackgroundMusic) {
        if let player = backgroundMusicPlayer {
            player.play()
            
        } else {
            guard let bundlePath = Bundle.main.path(
                forResource: track.filename,
                ofType: nil,
                inDirectory: "Media/BackgroundMusic"
            ) else {
                print("Background music file not found.")
                return
            }
            do {
                let url = URL(fileURLWithPath: bundlePath)
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("Could not load background music file: \(error)")
            }
        }
    }

    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }

    func setSoundEffectPlayerVolume(_ effect: SoundEffect, to volume: Float) {
        if let player = soundEffectPlayers[effect.filename] {
            player.setVolume(volume, fadeDuration: 0)
        }
    }
    
    func playSoundEffect(effect: SoundEffect) {
        if let player = soundEffectPlayers[effect.filename] {
            if effect == .squeakingGlass {
                player.setVolume(0, fadeDuration: 0)
                player.play()
                player.setVolume(0.15, fadeDuration: 0.5)
                
            } else {
                player.play()
            }
            
        } else {
            guard let bundlePath = Bundle.main.path(
                forResource: effect.filename,
                ofType: nil,
                inDirectory: "Media/SoundEffects"
            ) else {
                print("Background music file not found.")
                return
            }
            do {
                let url = URL(fileURLWithPath: bundlePath)
                let soundPlayer = try AVAudioPlayer(contentsOf: url)
                soundPlayer.prepareToPlay()
                soundEffectPlayers[effect.filename] = soundPlayer
                
                if effect == .squeakingGlass {
                    soundPlayer.setVolume(0, fadeDuration: 0)
                    soundPlayer.play()
                    soundPlayer.setVolume(0.15, fadeDuration: 0.5)
                    
                }
                else {
                    soundPlayer.play()
                }
            } catch {
                print("Could not load sound effect file: \(error)")
            }
        }
    }

    func stopSoundEffect(effect: SoundEffect) {
        soundEffectPlayers[effect.filename]?.setVolume(0, fadeDuration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.soundEffectPlayers[effect.filename]?.stop()
            self.soundEffectPlayers[effect.filename] = nil
        }
    }
}
