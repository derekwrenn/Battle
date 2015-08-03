//
//  Cannon.swift
//  Battle
//
//  Created by Derek on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Cannon: Pirate {
    override func fire(){
        stopAllActions()
        animationManager.runAnimationsForSequenceNamed("fire")
    }
    
    //    func fire(direction: Side) {
    //        if ammo > 20 {
    //            // create and add a new obstacle
    //            let lazer = CCBReader.load("Lazer")
    //            lazer.zOrder = 100
    //            addChild(lazer)
    //            lazer.position = bulletSpawnPoint.positionInPoints
    //
    //
    //            // shoots up or down on the screen based on the argument that is passed in
    //            if direction == .Up {
    //                lazer.physicsBody.applyImpulse(ccp(0, 500))
    //            } else if direction == .Down {
    //                lazer.physicsBody.applyImpulse(ccp(0, -500))
    //            }
    //
    //            if firstShot == true { // if this is the first shot, start the timer
    //                var shipFireRateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("cooldown"), userInfo: nil, repeats: true)
    //            }
    //
    //            firstShot = false // not the first shot anymore
    //
    //            //decrement the ammo
    //            ammo -= 10
    //        }
    //    }

    
}
