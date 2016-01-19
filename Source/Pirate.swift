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
    var isDead = false
    
    override func update(delta: CCTime) {
        if health <= 0 && stateOfCharacter != .dead{
            stateOfCharacter = .dead
            runDeadAnimation()
        }
    }
    
    func runDeadAnimation(){
        animationManager.runAnimationsForSequenceNamed("dead")
    }
    
    func pirateIsDead(){
        isDead = true
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
    }
    
    func changeToRunning() {
        stateOfCharacter = .running
    }
    
    func changeToIdle() {
        stateOfCharacter = .idle
    }
    
    func gotHit() {
        animationManager.runAnimationsForSequenceNamed("hit")
    }
}