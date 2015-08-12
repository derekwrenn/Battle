//
//  WinnerDad.swift
//  Battle
//
//  Created by Developer on 8/10/15.
//

import Foundation

class WinnerDad: CCScene {
    func restart(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    func mainScene(){
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
}
