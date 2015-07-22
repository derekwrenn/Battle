//
//  Gameplay.swift
//  Battle
//
//  Created by Derek Wrenn on 7/10/15.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate{
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    //The 2 Ships that are controlled by the users
    weak var bottomShip: Ship!
    weak var topShip: Ship!
    
    //The 3 bottom lane nodes
    weak var bottomLeftNode: CCNode!
    weak var bottomMiddleNode: CCNode!
    weak var bottomRightNode: CCNode!
    
    //The 3 top lane nodes
    weak var topLeftNode: CCNode!
    weak var topMiddleNode: CCNode!
    weak var topRightNode: CCNode!
    
    //The 2 health bars
    weak var bottomHealthBar: CCNode!
    weak var topHealthBar: CCNode!
    
    //The 2 cooldown bars
    weak var bottomCooldownBar: CCNodeColor!
    weak var topCooldownBar: CCNodeColor!
    
    //The location enum that's used throughout this file
    enum location{
        case bottomLeft, bottomMiddle, bottomRight, topLeft, topMiddle, topRight, none
    }
    
    override func update(delta: CCTime) {
        bottomCooldownBar.scaleX = Float(bottomShip.ammo) * 0.01
        topCooldownBar.scaleX = Float(topShip.ammo) * 0.01
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.collisionDelegate = self
    }
    
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, lazer: CCNode!, ship: Ship!) {
        lazer.removeFromParent()
        if bottomShip == ship {
            bottomHealthBar.scaleX -= 0.05
            bottomShip.health -= 5
            
        } else if topShip == ship {
            topHealthBar.scaleX -= 0.05
            topShip.health -= 5
        }
        
        if ship.health == 0 {
            ship.removeFromParent()
            if bottomShip.health == 0 {
                //blue wins
                let blueWinnerScene = CCBReader.loadAsScene("BlueWinner")
                CCDirector.sharedDirector().presentScene(blueWinnerScene)
            } else if topShip.health == 0 {
                //red wins
                let redWinnerScene = CCBReader.loadAsScene("RedWinner")
                CCDirector.sharedDirector().presentScene(redWinnerScene)
            }
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        //stores which of the 6 nodes on the screen was touched in the screenTouch var
        var screenTouch = whereScreenIsTouched(touch)
        
        //passes in the location and either moves or fires the ship
        moveOrFire(screenTouch)
    }
    
    func whereScreenIsTouched(touch : CCTouch) -> location{
        //Uses CCDirector to divide the screen into thirds in the x direction and in half in the y direction
        var screenLeftx = CCDirector.sharedDirector().viewSize().width / 3 //left lane line
        var screenRightx = screenLeftx * 2                                 //right lane line
        
        var screenHalfy = CCDirector.sharedDirector().viewSize().height / 2  //middle dividing line
        
        //stores the location of the touch on the screen (x and y)
        var locationOfTouch = touch.locationInNode(bottomLeftNode)
        
        //sets up a variable that stores where the screen was touched
        var whereScreenIsTouched : location = .none
        
        //algorithm that decides where the screen was touched
        if locationOfTouch.y < screenHalfy /* bottom half of screen */{
            if locationOfTouch.x < screenLeftx /* left side of screen */{
                whereScreenIsTouched = .bottomLeft
            } else if locationOfTouch.x < screenRightx /* middle of screen */{
                whereScreenIsTouched = .bottomMiddle
            } else if locationOfTouch.x > screenRightx /* right side of screen */{
                whereScreenIsTouched = .bottomRight
            }
        } else if locationOfTouch.y > screenHalfy /* top half of screen */{
            if locationOfTouch.x < screenLeftx /* left side of screen */ {
                whereScreenIsTouched = .topLeft
            } else if locationOfTouch.x < screenRightx /* middle of screen */ {
                whereScreenIsTouched = .topMiddle
            } else if locationOfTouch.x > screenRightx /* right side of screen */ {
                whereScreenIsTouched = .topRight
            }
        }
        return whereScreenIsTouched

    }
    
    func moveOrFire(touch : location){
        //switch statement that moves or fires the ship
        switch touch {
        case .bottomLeft:
            if bottomShip.sideOfShip == .Left {
                bottomShip.fire(.Up)
            } else if bottomShip.sideOfShip == .Middle {
                bottomShip.move(bottomLeftNode.positionInPoints)
                bottomShip.sideOfShip = .Left
            } else if bottomShip.sideOfShip == .Right {
                bottomShip.move(bottomMiddleNode.positionInPoints)
                bottomShip.sideOfShip = .Middle
            }
            
        case .bottomMiddle:
            if bottomShip.sideOfShip == .Left || bottomShip.sideOfShip == .Right {
                bottomShip.move(bottomMiddleNode.positionInPoints)
                bottomShip.sideOfShip = .Middle
            } else if bottomShip.sideOfShip == .Middle {
                bottomShip.fire(.Up)
            }
            
        case .bottomRight:
            if bottomShip.sideOfShip == .Left {
                bottomShip.move(bottomMiddleNode.positionInPoints)
                bottomShip.sideOfShip = .Middle
            } else if bottomShip.sideOfShip == .Middle {
                bottomShip.move(bottomRightNode.positionInPoints)
                bottomShip.sideOfShip = .Right
            } else if bottomShip.sideOfShip == .Right {
                bottomShip.fire(.Up)
            }
            
        case .topLeft:
            if topShip.sideOfShip == .Left {
                topShip.fire(.Down)
            } else if topShip.sideOfShip == .Middle {
                topShip.move(topLeftNode.positionInPoints)
                topShip.sideOfShip = .Left
            } else if topShip.sideOfShip == .Right {
                topShip.move(topMiddleNode.positionInPoints)
                topShip.sideOfShip = .Middle
            }
            
        case .topMiddle:
            if topShip.sideOfShip == .Left || topShip.sideOfShip == .Right {
                topShip.move(topMiddleNode.positionInPoints)
                topShip.sideOfShip = .Middle
            } else if topShip.sideOfShip == .Middle {
                topShip.fire(.Down)
            }
            
        case .topRight:
            if topShip.sideOfShip == .Left {
                topShip.move(topMiddleNode.positionInPoints)
                topShip.sideOfShip = .Middle
            } else if topShip.sideOfShip == .Middle {
                topShip.move(topRightNode.positionInPoints)
                topShip.sideOfShip = .Right
            } else if topShip.sideOfShip == .Right {
                topShip.fire(.Down)
            }
        default:
            println("wayyyyyy up i feel blessed")
    }
        


}
}


