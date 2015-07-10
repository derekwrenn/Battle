//
//  Ship.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import UIKit

class Ship: CCSprite {
    
    weak var bulletSpawnPoint: CCNode!
    var sideOfShip : Side = .Left
    
    enum Side{
        case Left, Right, Up, Down
    }
    
    func move(destination: CGPoint) {
        self.positionInPoints = destination
    }
    
    func fire(direction: Side) {
        // create and add a new obstacle
        let lazer = CCBReader.load("Lazer")
        lazer.zOrder = 100
        addChild(lazer)
        lazer.position = bulletSpawnPoint.positionInPoints
        
        if direction == .Up {
            lazer.physicsBody.applyImpulse(ccp(0, 200))
        } else if direction == .Down {
            lazer.physicsBody.applyImpulse(ccp(0, -200))
        }
    }
    
}
