//
//  Gameplay.swift
//  Battle
//
//  Created by Derek Wrenn on 7/10/15.
//

import Foundation

// The location enum that's used throughout this project
enum location{
    case right, left, middle, bottomLeft, bottomMiddle, bottomRight, topLeft, topMiddle, topRight, up, down, none
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    //The 4 bottom lane nodes
    weak var bottomLeftNode: CCNode!
    weak var bottomMiddleLeftNode: CCNode!
    weak var bottomMiddleRightNode: CCNode!
    weak var bottomRightNode: CCNode!
    
    //The 4 top lane nodes
    weak var topLeftNode: CCNode!
    weak var topMiddleLeftNode: CCNode!
    weak var topMiddleRightNode: CCNode!
    weak var topRightNode: CCNode!
    
    //The 2 players
    weak var pirateSon: Pirate!
    weak var pirateDad: Pirate!
    
    //The 6 cannons
    weak var topLeftCannon: Cannon!
    weak var topMiddleCannon: Cannon!
    weak var topRightCannon: Cannon!
   
    weak var bottomLeftCannon: Cannon!
    weak var bottomMiddleCannon: Cannon!
    weak var bottomRightCannon: Cannon!
    
    //The 2 respawn points
    weak var spawnAmmoHealthLeft: CCNode!
    weak var spawnAmmoHealthRight: CCNode!
    
    //topship code connection (used later for movement on the top side)
    weak var topShip: CCNode!
    
    //first thing that runs when the .ccb is loaded
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.collisionDelegate = self
        gamePhysicsNode.debugDraw = true
        var ammoAndHealthSpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(2.0), target: self, selector: Selector("dropHealthOrAmmo"), userInfo: nil, repeats: true)
    }
    
    func dropHealthOrAmmo(){
        spawnAmmo()
        spawnHealth()
    }
    
    func spawnAmmo(){
        let ammo = CCBReader.load("Ammo")
        gamePhysicsNode.addChild(ammo)
        ammo.position = spawnAmmoHealthLeft.positionInPoints
        ammo.physicsBody.applyImpulse(ccp(100,0))
    }
    
    func spawnHealth(){
        let health = CCBReader.load("Health")
        gamePhysicsNode.addChild(health)
        health.position = spawnAmmoHealthRight.positionInPoints
        health.physicsBody.applyImpulse(ccp(-100,0))
    }
    
    //collision that is triggered when a cannonball hits a pirate
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, cannonball: CCSprite!, pirate: Pirate!) {
        cannonball.removeFromParent()
        pirate.gotHit()
    }
    
    //collision when a pirate hits health
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, health: CCSprite!, pirate: Pirate!) {
        health.removeFromParent()
        pirate.health++
    }
    
    //collision when a pirate hits ammmo
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, ammo: CCSprite!, pirate: Pirate!) {
        ammo.removeFromParent()
        pirate.ammo++
    }
    
    //3 class variables that are used in the touch functions to determine swipes and taps
    var touchBeganLocation : CGPoint = ccp(0,0)
    var touchMovedLocation : CGPoint = ccp(0,0)
    var nodeOfTouch : location = .none

    //function that is triggered when a user touch begins
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var screenTouch : location = whereScreenIsTouched(touch) //stores the enum where the screen was touched
        nodeOfTouch = screenTouch                                //saves that enum into the class variable
        touchBeganLocation = touch.locationInWorld()             //stores the touch location into the class variable
        moveOrFire(screenTouch)                                  //passes the enum into the moveOrFire function
    }
    
    //function that is triggered when the user moves their touch
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touchMovedLocation = touch.locationInWorld() //stores the touch locations into the class variable
        
        //if the touch originated in the bottom 3 nodes, the pirate is not jumping, and if the length of the swipe up becomes
        //between 50 and 75 pixels, then jump the pirateSon.
        if nodeOfTouch == .bottomLeft || nodeOfTouch == .bottomMiddle || nodeOfTouch == .bottomRight {
            if pirateSon.isjumping == false {
                    if touchMovedLocation.y - touchBeganLocation.y >= 50 && touchMovedLocation.y - touchBeganLocation.y <= 75 {
                        pirateSon.jump()
                    }
            }
        }
        //else if the touch originated in the top 3 nodes, the pirate is not jumping, and if the length of the swipe down becomes
        //between 50 and 75 pixels, then jump the pirateDad.
        else if nodeOfTouch == .topLeft || nodeOfTouch == .topMiddle || nodeOfTouch == .topRight {
            if pirateDad.isjumping == false {
                if touchBeganLocation.y - touchMovedLocation.y >= 50 && touchBeganLocation.y - touchMovedLocation.y <= 75 {
                    pirateDad.jump()
                }
            }
        }
    }
    
    //function that is triggered when the user ends their touch
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
   
    }
    
    //function that divids the screen up into 6 sections and returns the location of the touch that is passed in
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
            if locationOfTouch.x < screenLeftx { whereScreenIsTouched = .bottomLeft }
            else if locationOfTouch.x < screenRightx { whereScreenIsTouched = .bottomMiddle }
            else if locationOfTouch.x > screenRightx { whereScreenIsTouched = .bottomRight }
        } else if locationOfTouch.y > screenHalfy /* top half of screen */{
            if locationOfTouch.x < screenLeftx { whereScreenIsTouched = .topLeft }
            else if locationOfTouch.x < screenRightx { whereScreenIsTouched = .topMiddle }
            else if locationOfTouch.x > screenRightx { whereScreenIsTouched = .topRight }
        }
        
        return whereScreenIsTouched
    }
    
    //function that either moves the pirate or fires that cannon depending on where the pirate is
    func moveOrFire(touch : location){
        
        //if the son isn't jumping, runs the switch statement
        if pirateSon.isjumping == false {
            switch touch {
                case .bottomLeft:
                    if pirateSon.sideOfCharacter == .left && pirateSon.stateOfCharacter == .idle {
                        bottomLeftCannon.fire(.up)
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
                        bottomMiddleCannon.fire(.up)
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
                        bottomRightCannon.fire(.up)
                        pirateSon.fire()
                    }
                default:
                    print("")
            }
        }
        
        //if the dad isn't jumping, run the switch statement
        if pirateDad.isjumping == false {
            switch touch {
                case .topLeft:
                    if pirateDad.sideOfCharacter == .left && pirateDad.stateOfCharacter == .idle {
                        topLeftCannon.fire(.down)
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
                        topMiddleCannon.fire(.down)
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
                        topRightCannon.fire(.down)
                        pirateDad.fire()
                    }
                default:
                    print("")
            }
        }
    }
}