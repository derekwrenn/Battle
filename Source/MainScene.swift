//
//  MainScene.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

class MainScene: CCScene {

    
    
    func twoPlayer(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func mainScene(){
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }

}