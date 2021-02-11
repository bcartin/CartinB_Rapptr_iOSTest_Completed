//
//  SoundManager.swift
//  iOSTest
//
//  Created by Bernie Cartin on 2/11/21.
//  Copyright © 2021 D&ATechnologies. All rights reserved.
//

import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            }
            catch {
                print("Error: Could not find and play the sound file.")
            }
        }
    }
}
