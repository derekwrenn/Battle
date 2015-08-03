//
//  Gameplay.swift
//  Battle
//
//  Created by Derek Wrenn on 7/10/15.
//

import Foundation

//The location enum that's used throughout this file
enum location{
    case right, left, middle, bottomLeft, bottomMiddle, bottomRight, topLeft, topMiddle, topRight, none
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var gamePhysicsNode: CCPhysicsNode!

    
    //The 3 bottom lane nodes
    weak var bottomLeftNode: CCNode!
    weak var bottomMiddleLeftNode: CCNode!
    weak var bottomMiddleRightNode: CCNode!
    weak var bottomRightNode: CCNode!
    
    //The 3 top lane nodes
    weak var topLeftNode: CCNode!
    weak var topMiddleLeftNode: CCNode!
    weak var topMiddleRightNode: CCNode!
    weak var topRightNode: CCNode!
    
    //Son and Father Pirates
    weak var pirateSon: Pirate!
    weak var pirateDad: Pirate!
    
    //6 cannons
    weak var topLeftCannon: Cannon!
    weak var topMiddleCannon: Cannon!
    weak var topRightCannon: Cannon!
   
    weak var bottomLeftCannon: Cannon!
    weak var bottomMiddleCannon: Cannon!
    weak var bottomRightCannon: Cannon!
    
    weak var topShip: CCNode!
    
    override func update(delta: CCTime) {
      
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.collisionDelegate = self
    }
    
//    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, lazer: CCNode!, ship: Ship!) {
//        lazer.removeFromParent()
//        if bottomShip == ship {
//            bottomHealthBar.scaleX -= 0.05
//            bottomShip.health -= 5
//            
//        } else if topShip == ship {
//            topHealthBar.scaleX -= 0.05
//            topShip.health -= 5
//        }
//        
//        if ship.health == 0 {
//            ship.removeFromParent()
//            if bottomShip.health == 0 {
//                //blue wins
//                //let blueWinnerScene = CCBReader.loadAsScene("BlueWinner")
//                //CCDirector.sharedDirector().presentScene(blueWinnerScene)
//            } else if topShip.health == 0 {
//                //red wins
//                let redWinnerScene = CCBReader.loadAsScene("RedWinner")
//                CCDirector.sharedDirector().presentScene(redWinnerScene)
//            }
//        }
//    }
    
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
        switch touch {
        case .bottomLeft:
            if pirateSon.sideOfCharacter == .left && pirateSon.stateOfCharacter == .idle {
                bottomLeftCannon.fire()
                pirateSon.fire()
            } else if pirateSon.sideOfCharacter == .middle {
                pirateSon.flipX = true
                pirateSon.move(bottomLeftNode.positionInPoints, time: 0.25)
                pirateSon.sideOfCharacter = .left
            } else if pirateSon.sideOfCharacter == .right {
                pirateSon.flipX = true
                pirateSon.move(bottomLeftNode.positionInPoints, time: 0.5)
                pirateSon.sideOfCharacter = .left
            }
           
            
        case .bottomMiddle:
            if pirateSon.sideOfCharacter == .left {
                pirateSon.flipX = false
                pirateSon.move(bottomMiddleLeftNode.positionInPoints, time: 0.25)
                pirateSon.sideOfCharacter = .middle
            } else if pirateSon.sideOfCharacter == .middle && pirateSon.stateOfCharacter == .idle {
                bottomMiddleCannon.fire()
                pirateSon.fire()
            } else if pirateSon.sideOfCharacter == .right {
                pirateSon.flipX = true
                pirateSon.move(bottomMiddleRightNode.positionInPoints, time: 0.25)
                pirateSon.sideOfCharacter = .middle
            }
           
            
        case .bottomRight:
            if pirateSon.sideOfCharacter == .left {
                pirateSon.flipX = false
                pirateSon.move(bottomRightNode.positionInPoints, time: 0.5)
                pirateSon.sideOfCharacter = .right
            } else if pirateSon.sideOfCharacter == .middle {
                pirateSon.flipX = false
                pirateSon.move(bottomRightNode.positionInPoints, time: 0.25)
                pirateSon.sideOfCharacter = .right
            } else if pirateSon.sideOfCharacter == .right && pirateSon.stateOfCharacter == .idle {
                bottomRightCannon.fire()
                pirateSon.fire()
            }
         
            
        case .topLeft:
            if pirateDad.sideOfCharacter == .left && pirateDad.stateOfCharacter == .idle {
                topLeftCannon.fire()
                pirateDad.fire()
            } else if pirateDad.sideOfCharacter == .middle {
                pirateDad.flipX = false
                pirateDad.move(topShip.convertToWorldSpace(topLeftNode.positionInPoints), time: 0.25)
                pirateDad.sideOfCharacter = .left
            } else if pirateDad.sideOfCharacter == .right {
                pirateDad.flipX = false
                pirateDad.move(topShip.convertToWorldSpace(topLeftNode.positionInPoints), time: 0.5)
                pirateDad.sideOfCharacter = .left
            }
            
            
        case .topMiddle:
            if pirateDad.sideOfCharacter == .left {
                pirateDad.flipX = true
                pirateDad.move(topShip.convertToWorldSpace(topMiddleLeftNode.positionInPoints), time: 0.25)
                pirateDad.sideOfCharacter = .middle
            } else if pirateDad.sideOfCharacter == .middle && pirateDad.stateOfCharacter == .idle {
                topMiddleCannon.fire()
                pirateDad.fire()
            } else if pirateDad.sideOfCharacter == .right {
                pirateDad.flipX = false
                pirateDad.move(topShip.convertToWorldSpace(topMiddleRightNode.positionInPoints), time: 0.25)
                pirateDad.sideOfCharacter = .middle
            }
            
            
        case .topRight:
            if pirateDad.sideOfCharacter == .left {
                pirateDad.flipX = true
                pirateDad.move(topShip.convertToWorldSpace(topRightNode.positionInPoints), time: 0.5)
                pirateDad.sideOfCharacter = .right
            } else if pirateDad.sideOfCharacter == .middle {
                pirateDad.flipX = true
                pirateDad.move(topShip.convertToWorldSpace(topRightNode.positionInPoints), time: 0.25)
                pirateDad.sideOfCharacter = .right
            } else if pirateDad.sideOfCharacter == .right && pirateDad.stateOfCharacter == .idle {
                topRightCannon.fire()
                pirateDad.fire()
            }
        default:
            println("boom")
        }
        


    }
}


