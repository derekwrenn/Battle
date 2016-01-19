//
//  Gameplay.swift
//  Battle
//
//  Created by Derek Wrenn on 7/10/15.
//

import Foundation

// The location enum that's used throughout this project
enum location{
    case right, left, middle, top, bottom, bottomLeft, bottomMiddle, bottomRight, topLeft, topMiddle, topRight, up, down, none
}

class Gameplay: CCScene, CCPhysicsCollisionDelegate {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var mainNode: CCPhysicsNode!
    
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
    
    //The 4 boxes
    weak var bottomAmmoBox: CCLayoutBox!
    weak var bottomHealthBox: CCLayoutBox!
    weak var topHealthBox: CCLayoutBox!
    weak var topAmmoBox: CCLayoutBox!
    
    //Self explanitory
    var healthSpawnTimer : NSTimer!
    var ammoSpawnTimer : NSTimer!
    var jumpTimerBottom : NSTimer!
    var jumpTimerTop: NSTimer!
    
    override func update(delta: CCTime) {
        if pirateSon.isDead == true{
            healthSpawnTimer.invalidate()
            ammoSpawnTimer.invalidate()
            let dadWinnerScene = CCBReader.loadAsScene("WinnerDad")
            CCDirector.sharedDirector().presentScene(dadWinnerScene)
        }
        
        else if pirateDad.isDead == true{
            healthSpawnTimer.invalidate()
            ammoSpawnTimer.invalidate()
            let sonWinnerScene = CCBReader.loadAsScene("WinnerSon")
            CCDirector.sharedDirector().presentScene(sonWinnerScene)
        }
    }
    
    //first thing that runs when the .ccb is loaded
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        gamePhysicsNode.collisionDelegate = self
        //gamePhysicsNode.debugDraw = true
        countdown()
        healthSpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(10.0), target: self, selector: Selector("spawnHealth"), userInfo: nil, repeats: true)
        ammoSpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(2.0), target: self, selector: Selector("spawnAmmo"), userInfo: nil, repeats: true)
    }
    
    func countdown(){
        animationManager.runAnimationsForSequenceNamed("Countdown")
        pirateDad.ammo = 0
        pirateSon.ammo = 0
    }
    
    func giveAmmoBack(){
        pirateDad.ammo = 5
        pirateSon.ammo = 5
    }
    
 
    func makeSonJump(){
        if pirateSon.isjumping == false {
            pirateSon.jump()
            firstJumpBottom = true
        }
    }
    
    func makeDadJump(){
        if pirateDad.isjumping == false {
            pirateDad.jump()
            firstJumpTop = true
        }
    }
    
    func spawnAmmo(){
        let ammo = CCBReader.load("Ammo")
        gamePhysicsNode.addChild(ammo)
        ammo.position = spawnAmmoHealthLeft.positionInPoints
        
        let width = CCDirector.sharedDirector().viewSize().width
        let move = CCActionMoveBy(duration: 4.0, position: ccp(width*1.3,0))
        ammo.runAction(CCActionSequence(array: [move, CCActionRemove()]))
        ammo.physicsBody.applyAngularImpulse(-500)
    }
    
    func spawnHealth(){
        let health = CCBReader.load("Health")
        gamePhysicsNode.addChild(health)
        health.position = spawnAmmoHealthRight.positionInPoints
        
        let width = CCDirector.sharedDirector().viewSize().width
        let move = CCActionMoveBy(duration: 4.0, position: ccp(-width*1.3,0))
        health.runAction(CCActionSequence(array: [move, CCActionRemove()]))
        health.physicsBody.applyAngularImpulse(500)
    }
    
    //collision that is triggered when a cannonball hits a pirate
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, cannonball: CCSprite!, pirate: Pirate!) {
        cannonball.removeFromParent()
        pirate.gotHit()
        pirate.health--
        
        if pirate == pirateSon {
            let sonHeart = bottomHealthBox.children[pirateSon.health] as! CCSprite
            sonHeart.visible = false
        }
        else if pirate == pirateDad {
            let dadHeart = topHealthBox.children[pirateDad.health] as! CCSprite
            dadHeart.visible = false
        }
    }
    
    //collision when a pirate hits health
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, health: CCSprite!, pirate: Pirate!) {
        health.removeFromParent()
        if pirate == pirateSon && pirateSon.health < 5 {
            pirateSon.health++
            let sonHeart = bottomHealthBox.children[pirateSon.health - 1] as! CCSprite
            sonHeart.visible = true
        }
        else if pirate == pirateDad && pirateDad.health < 5 {
            pirateDad.health++
            let dadHeart = topHealthBox.children[pirateDad.health - 1] as! CCSprite
            dadHeart.visible = true
        }
    }
    
    //collision when a pirate hits ammmo
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, ammo: CCSprite!, pirate: Pirate!) {
        gamePhysicsNode.space.addPostStepBlock({ () -> Void in
            ammo.removeFromParent()
        }, key: ammo)
        
        
        gamePhysicsNode.space.addPostStepBlock({ () -> Void in

        if pirate.ammo < 5{
            pirate.ammo++
        }
        if pirate == self.pirateSon && self.pirateSon.ammo <= 5 {
            let sonAmmo = self.bottomAmmoBox.children[self.pirateSon.ammo - 1] as! CCSprite
            sonAmmo.visible = true
        }
        else if pirate == self.pirateDad && self.pirateDad.ammo <= 5 {
            let dadAmmo = self.topAmmoBox.children[self.pirateDad.ammo - 1] as! CCSprite
            dadAmmo.visible = true
        
            }
        }, key: pirate)
    }
    

    func simplifyEnum(oldLocation : location) -> location{
        var newLocation : location = .none
        
        if oldLocation == .bottomLeft || oldLocation == .bottomMiddle || oldLocation == .bottomRight{
            newLocation = .bottom
        }
        else if oldLocation == .topLeft || oldLocation == .topMiddle || oldLocation == .topRight{
            newLocation = .top
        }
        
        return newLocation
    }
    
    var touchSideStart : location = .none
    var touchSideEnd : location = .none
    var firstJumpBottom = false
    var firstJumpTop = false
    //function that is triggered when a user touch begins
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        
        let screenTouch : location = whereScreenIsTouched(touch) //stores the enum where the screen was touched
        touchSideStart = simplifyEnum(screenTouch)
        
        if firstJumpBottom == true && touchSideStart == .bottom {
            if let inval = jumpTimerBottom{
                inval.invalidate()
            }
        } else if firstJumpTop == true && touchSideStart == .top{
            if let inval = jumpTimerTop{
                inval.invalidate()
            }
        }
        
        
        if touchSideStart == .bottom{
            jumpTimerBottom = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.15),
                                                               target: self,
                                                               selector: Selector("makeSonJump"),
                                                               userInfo: nil,
                                                               repeats: false)
        } else if touchSideStart == .top{
            jumpTimerTop = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.15),
                                                               target: self,
                                                               selector: Selector("makeDadJump"),
                                                               userInfo: nil,
                                                               repeats: false)
        }
    }
    
    //function that is triggered when the user ends their touch
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let screenTouch : location = whereScreenIsTouched(touch) //stores the enum where the screen was touched
        moveOrFire(screenTouch)                                  //passes the enum into the moveOrFire function
        touchSideEnd = simplifyEnum(screenTouch)
        
        if touchSideEnd == .bottom{
            if let inval = jumpTimerBottom{
                inval.invalidate()
            }
        } else if touchSideEnd == .top{
            if let inval = jumpTimerTop{
                inval.invalidate()
            }
        }
        
    }
    
    //function that divids the screen up into 6 sections and returns the location of the touch that is passed in
    func whereScreenIsTouched(touch : CCTouch) -> location{
        //Uses CCDirector to divide the screen into thirds in the x direction and in half in the y direction
        let screenLeftx = CCDirector.sharedDirector().viewSize().width / 3 //left lane line
        let screenRightx = screenLeftx * 2                                 //right lane line
        
        let screenHalfy = CCDirector.sharedDirector().viewSize().height / 2  //middle dividing line
        
        //stores the location of the touch on the screen (x and y)
        let locationOfTouch = touch.locationInNode(bottomLeftNode)
        
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
                        if pirateSon.ammo > 0 {
                            pirateSon.fire()
                            bottomLeftCannon.fire(.up)
                            let sonAmmo = bottomAmmoBox.children[pirateSon.ammo] as! CCSprite
                            sonAmmo.visible = false
                        }
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
                        if pirateSon.ammo > 0 {
                            pirateSon.fire()
                            bottomMiddleCannon.fire(.up)
                            let sonAmmo = bottomAmmoBox.children[pirateSon.ammo] as! CCSprite
                            sonAmmo.visible = false
                        }
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
                        if pirateSon.ammo > 0 {
                            pirateSon.fire()
                            bottomRightCannon.fire(.up)
                            let sonAmmo = bottomAmmoBox.children[pirateSon.ammo] as! CCSprite
                            sonAmmo.visible = false
                        }
                    }
                default:
                    print("", terminator: "")
            }
        }
        
        //if the dad isn't jumping, run the switch statement
        if pirateDad.isjumping == false {
            switch touch {
                case .topLeft:
                    if pirateDad.sideOfCharacter == .left && pirateDad.stateOfCharacter == .idle {
                        if pirateDad.ammo > 0 {
                            pirateDad.fire()
                            topLeftCannon.fire(.down)
                            let dadAmmo = topAmmoBox.children[pirateDad.ammo] as! CCSprite
                            dadAmmo.visible = false
                        }
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
                        if pirateDad.ammo > 0 {
                            pirateDad.fire()
                            topMiddleCannon.fire(.down)
                            let dadAmmo = topAmmoBox.children[pirateDad.ammo] as! CCSprite
                            dadAmmo.visible = false
                        }
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
                        if pirateDad.ammo > 0 {
                            pirateDad.fire()
                            topRightCannon.fire(.down)
                            let dadAmmo = topAmmoBox.children[pirateDad.ammo] as! CCSprite
                            dadAmmo.visible = false
                        }
                    }
                default:
                    print("", terminator: "")
            }
        }
    }
}