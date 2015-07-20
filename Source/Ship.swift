//
//  Ship.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import UIKit

class Ship: CCSprite {
    
    weak var bulletSpawnPoint: CCNode!
    var sideOfShip : Side = .Middle
    var health : Int = 100
    var ammo : Int = 100
    var firstShot : Bool = true
    
    enum Side{
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
    
    func move(destination: CGPoint) {
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

