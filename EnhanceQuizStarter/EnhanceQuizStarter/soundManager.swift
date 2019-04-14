//
//  soundManager.swift
//  EnhanceQuizStarter
//
//  Created by Joel Arias on 06/04/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import AudioToolbox

class SoundManager{
    
    var gameSound: SystemSoundID
    var tapSound: SystemSoundID
    var negativeSound: SystemSoundID
    var positiveSound: SystemSoundID
    
    init(gameSound: SystemSoundID, tapSound: SystemSoundID, negativeSound: SystemSoundID, positiveSound: SystemSoundID) {
        
        self.gameSound = gameSound
        self.tapSound = tapSound
        self.negativeSound = negativeSound
        self.positiveSound = positiveSound
    }
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func loadTapSound(){
        let path = Bundle.main.path(forResource: "tapSound", ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &tapSound)
    }
    
    func loadNegativeSound(){
        let path = Bundle.main.path(forResource: "errorSound", ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &negativeSound)
    }
    
    func loadPositiveSound(){
        let path = Bundle.main.path(forResource: "correctSound", ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &positiveSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playTapSound(){
        AudioServicesPlaySystemSound(tapSound)
    }
    
    func playNegativeSound(){
        AudioServicesPlaySystemSound(negativeSound)
    }
    
    func playPositiveSound(){
        AudioServicesPlaySystemSound(positiveSound)
    }
}
