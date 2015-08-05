//
//  Cannon.swift
//  Battle
//
//  Created by Derek on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Cannon: Pirate {
    
    weak var spawn: CCNode!
    
        func fire(direction: location) {
            
            stopAllActions()
            animationManager.runAnimationsForSequenceNamed("fire")
            
            // create and add a new obstacle
            let cannonball = CCBReader.load("Cannonball")
            cannonball.zOrder = 100
            self.parent.parent.addChild(cannonball)
            cannonball.position = self.convertToWorldSpace(spawn.positionInPoints)
    
    
            // shoots up or down on the screen based on the argument that is passed in
            if direction == .up {
                cannonball.physicsBody.applyImpulse(ccp(0, 200))
            } else if direction == .down {
                cannonball.physicsBody.applyImpulse(ccp(0, -200))
            }
            
        }

    
}
