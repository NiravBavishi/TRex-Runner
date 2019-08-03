//
//  AudioPlayer.swift
//  TRexRunnerGame
//
//  Created by Abita Shiney on 2019-02-16.
//  Copyright © 2019 Abita Shiney. All rights reserved.
//

import Foundation
import SpriteKit

let kSoundState = "kSoundState"
let kBackgroundMusicName = "SnowySound"
let kBackgroundMusicExtension = "wav"

enum SoundFileName: String {
    case TapFile = "Tap.wav"
}
class AudioPlayer {
    private init(){}
    static let shared = AudioPlayer()
    
    func setSounds(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: kSoundState)
        UserDefaults.standard.synchronize()
    }
    func getSound() -> Bool {
        return UserDefaults.standard.bool(forKey: kSoundState)
    }
}
