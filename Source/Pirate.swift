//
//  Pirate.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

enum state{
    case running, idle, shooting, none
}


class Pirate: CCSprite {
    var stateOfCharacter: state = .idle
    var sideOfCharacter: location = .middle
    
    func move(destination: CGPoint, time: CCTime) {
        stopAllActions()
        animationManager.runAnimationsForSequenceNamed("run")
        let sequence : CCActionSequence = CCActionSequence(array: [CCActionMoveTo(duration: time, position: destination), CCActionCallBlock(block: { () -> Void in
            self.animationManager.runAnimationsForSequenceNamed("idle")
        })])
        runAction(sequence)
    }
    
    func fire() {
        animationManager.runAnimationsForSequenceNamed("fire")
    }
    
    func changeToRunning() {
        stateOfCharacter = .running
    }
    
    func changeToIdle() {
        stateOfCharacter = .idle
    }
    
}

