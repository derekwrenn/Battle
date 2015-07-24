//
//  Ship.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

class Ship: CCSprite {
    
    weak var bulletSpawnPoint: CCNode!
    weak var laneSelector: CCNodeColor!
    var sideOfShip : Side = .Middle
    var health : Int = 100
    var ammo : Int = 100
    var firstShot : Bool = true
    
    enum Side {
        case Left, Middle, Right, Up, Down
    }
    
    func cooldown() { //used to cooldown the fire rate
        //increments the ammo every time the function is called
        if ammo < 20 {
            self.opacity = 0.5
        } else if ammo > 20 {
            self.opacity = 1
        }
        
        if ammo < 100 {
            ammo += 2
        }
    }
      
    func flash() {
        laneSelector.visible = true
        
        let sequence : CCActionSequence = CCActionSequence(array: [CCActionFadeTo(duration: 0.3, opacity: 0), CCActionCallBlock(block: { () -> Void in
            self.laneSelector.visible = false
            self.laneSelector.opacity = 0.2
        })])
        
        laneSelector.runAction(sequence)
    }
    
    func move(destination: CGPoint) {
        //stops all animations and makes the lane selector flash
        if laneSelector.numberOfRunningActions() > 0 {
            laneSelector.stopAllActions()
            laneSelector.opacity = 0.2
        }
        flash()
        
        //moves the ship
        self.positionInPoints = destination
    }
    
    func fire(direction: Side) {
        if ammo > 20 {
            // create and add a new obstacle
            let lazer = CCBReader.load("Lazer")
            lazer.zOrder = 100
            addChild(lazer)
            lazer.position = bulletSpawnPoint.positionInPoints
        
        
            // shoots up or down on the screen based on the argument that is passed in
            if direction == .Up {
                lazer.physicsBody.applyImpulse(ccp(0, 500))
            } else if direction == .Down {
                lazer.physicsBody.applyImpulse(ccp(0, -500))
            }
            
            if firstShot == true { // if this is the first shot, start the timer
                var shipFireRateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("cooldown"), userInfo: nil, repeats: true)
            }
        
            firstShot = false // not the first shot anymore
        
            //decrement the ammo
            ammo -= 10
        }
    }
}

