//
//  Pirate.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

enum state{
    case running, idle, shooting, hit, dead, none
}

class Pirate: CCSprite {
    var stateOfCharacter: state = .idle
    var sideOfCharacter: location = .middle
    var isjumping : Bool = false
    var health = 5
    var ammo = 5
    
    override func update(delta: CCTime) {
        if health <= 0 {
            stateOfCharacter = .dead
            println("DEAD!")
            //call the winner screen for the opposite pirate
        }
    }
    
    func move(destination: CGPoint, time: CCTime) {
        stopAllActions()
        animationManager.runAnimationsForSequenceNamed("run")
        let sequence : CCActionSequence = CCActionSequence(array: [CCActionMoveTo(duration: time, position: destination), CCActionCallBlock(block: { () -> Void in
            self.animationManager.runAnimationsForSequenceNamed("idle")
        })])
        runAction(sequence)
    }
    
    func jump() {
        isjumping = true
        var locationY: CGFloat = 0.0
        animationManager.runAnimationsForSequenceNamed("jump")
        let sequence : CCActionSequence = CCActionSequence(array: [
            CCActionMoveBy(duration: 0.5, position: ccp(0, 140)),
            CCActionMoveBy(duration: 0.5, position: ccp(0, -140)),
            CCActionCallBlock(block: { () -> Void in
                self.isjumping = false
            })
        ])
        runAction(sequence)
    }
    
    func fire() {
        animationManager.runAnimationsForSequenceNamed("fire")
        ammo--
        println("In Pirate: \(ammo)")
    }
    
    func changeToRunning() {
        stateOfCharacter = .running
    }
    
    func changeToIdle() {
        stateOfCharacter = .idle
    }
    
    func gotHit() {
        animationManager.runAnimationsForSequenceNamed("hit")
        health--
    }
}