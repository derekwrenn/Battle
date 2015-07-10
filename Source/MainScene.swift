//
//  MainScene.swift
//  Battle
//
//  Created by Derek Wrenn on 7/2/15.
//

import Foundation

class MainScene: CCNode {
    
    weak var redShip: Ship!
    weak var blueShip: Ship!
    weak var redSide: CCNode!
    weak var blueSide: CCNode!
    weak var rLeftNode: CCNode!
    weak var rRightNode: CCNode!
    weak var bLeftNode: CCNode!
    weak var bRightNode: CCNode!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
    }

    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        //Uses CCDirector to divide the screen into 4 quadrants
        var screenHalfx = CCDirector.sharedDirector().viewSize().width / 2   //left or right
        var screenHalfy = CCDirector.sharedDirector().viewSize().height / 2  //top or bottom
        
        //stores the location of the touch on the screen (x and y)
        var locationOfTouch = touch.locationInNode(redSide)
        
        //sets up a variable that stores where the screen was touched
        enum location{
            case blueLeft, blueRight, redLeft, redRight
        }
        var whereScreenIsTouched : location
        
        //algorithm that decides where the screen was touched
        if locationOfTouch.y < screenHalfy {
            if locationOfTouch.x < screenHalfx {
                whereScreenIsTouched = .redLeft
            } else {
                whereScreenIsTouched = .redRight
            }
        } else {
            if locationOfTouch.x < screenHalfx {
                whereScreenIsTouched = .blueRight
            } else {
                whereScreenIsTouched = .blueLeft
            }
        }
        
        //switch statement that determines whether to move the ship or fire a shot
        switch whereScreenIsTouched {
            case .redLeft:
                if redShip.sideOfShip == .Right {
                    redShip.move(rLeftNode.positionInPoints)
                    redShip.sideOfShip = .Left
                } else {
                    redShip.fire(.Up)
                }
            case .redRight:
                if redShip.sideOfShip == .Left{
                    redShip.move(rRightNode.positionInPoints)
                    redShip.sideOfShip = .Right
                } else {
                    redShip.fire(.Up)
                }
            case .blueLeft:
                if blueShip.sideOfShip == .Right {
                    blueShip.move(bLeftNode.positionInPoints)
                    blueShip.sideOfShip = .Left
                } else {
                    blueShip.fire(.Down)
                }
            case .blueRight:
                if blueShip.sideOfShip == .Left{
                    blueShip.move(bRightNode.positionInPoints)
                    blueShip.sideOfShip = .Right
                } else {
                    blueShip.fire(.Down)
                }
        }
        
    }
    
}
