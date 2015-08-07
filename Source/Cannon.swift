//
//  Cannon.swift
//  Battle
//
//  Created by Derek on 7/30/15.
//

import Foundation

class Cannon: Pirate {
    
    weak var spawn: CCNode!
    
    func fire(direction: location) {
        println("In Cannon: \(ammo)")
        if ammo > 0 {
            stopAllActions()
            animationManager.runAnimationsForSequenceNamed("fire")
            // create and add a new obstacle
            let cannonball = CCBReader.load("Cannonball")
            cannonball.scale = 1.5
            self.parent.parent.addChild(cannonball)
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
}
