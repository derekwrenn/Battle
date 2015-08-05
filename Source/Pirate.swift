//
//  Pirate.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

enum state{
    case running, idle, shooting, hit, none
}


class Pirate: CCSprite {
    var stateOfCharacter: state = .idle
    var sideOfCharacter: location = .middle
    var isjumping : Bool = false
    
    func move(destination: CGPoint, time: CCTime) {
        if isjumping == false {
        stopAllActions()
        animationManager.runAnimationsForSequenceNamed("run")
        let sequence : CCActionSequence = CCActionSequence(array: [CCActionMoveTo(duration: time, position: destination), CCActionCallBlock(block: { () -> Void in
            self.animationManager.runAnimationsForSequenceNamed("idle")
        })])
        runAction(sequence)
        }
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
        if isjumping == false{
        animationManager.runAnimationsForSequenceNamed("fire")
        }
    }
    
    func changeToRunning() {
        if isjumping == false{
        stateOfCharacter = .running
        }
    }
    
    func changeToIdle() {
        stateOfCharacter = .idle
    }
    
    func gotHit() {
        if isjumping == false{
        animationManager.runAnimationsForSequenceNamed("hit")
        }
    }
    
}

