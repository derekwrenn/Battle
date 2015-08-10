//
//  WinnerSon.swift
//  Battle
//
//  Created by Developer on 8/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class WinnerSon: CCScene {
    func restart(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
}
