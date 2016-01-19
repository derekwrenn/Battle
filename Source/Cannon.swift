//
//  Cannon.swift
//  Battle
//
//  Created by Derek Wrenn on 7/30/15.
//

import Foundation

class Cannon: CCSprite {
    
    weak var spawn: CCNode!
    
    func fire(direction: location) {
       
            stopAllActions()
            animationManager.runAnimationsForSequenceNamed("fire")
            // create and add a new obstacle
            let cannonball = CCBReader.load("Cannonball")
            cannonball.scale = 1.3
            self.parent!.parent!.addChild(cannonball)
            cannonball.position = self.convertToWorldSpace(spawn.positionInPoints)

            // shoots up or down on the screen based on the argument that is passed in
            if direction == .up {
                cannonball.physicsBody.applyImpulse(ccp(0, 200))
                cannonball.physicsBody.applyAngularImpulse(500)
            } else if direction == .down {
                cannonball.physicsBody.applyImpulse(ccp(0, -200))
                cannonball.physicsBody.applyAngularImpulse(-500)
            }
        
    }
}
