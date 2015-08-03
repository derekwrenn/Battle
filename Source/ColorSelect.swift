////
////  ColorSelect.swift
////  Battle
////
////  Created by Derek Wrenn on 7/21/15.
////
//
//import Foundation
//
//class ColorSelect: CCNode {
//   
//    weak var bottomGradient: CCNodeGradient!
//    weak var topGradient: CCNodeGradient!
//    
//    weak var bPickYourColor: CCLabelTTF!
//    weak var tPickYourColor: CCLabelTTF!
//    
//    weak var bNextButton: CCButton!
//    weak var tNextButton: CCButton!
//    
//    var bReady = false
//    var tReady = false
//    
//    func transitionToGameplay(buttonPressed: CCButton) {
//        if buttonPressed.name == "bNextButton" {
//            bNextButton.enabled = false
//            if tNextButton.enabled == false {
//                setColors()
//            }
//            
//        } else if buttonPressed.name == "tNextButton" {
//            tNextButton.enabled = false
//            if bNextButton.enabled == false {
//                setColors()
//            }
//        }
//    }
//    
//    func setColors() {
//        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
//        var newScene : CCScene = CCScene()
//        gameplayScene.bottomGradient.startColor = self.bottomGradient.startColor
//        gameplayScene.topGradient.startColor = self.topGradient.startColor
//        gameplayScene.bottomCooldownBar.color = self.bottomGradient.startColor
//        gameplayScene.topCooldownBar.color = self.topGradient.startColor
//        newScene.addChild(gameplayScene)
//        CCDirector.sharedDirector().presentScene(newScene)
//    }
//
//    
//    func changeColor(buttonPressed: CCButton) {
//        switch buttonPressed.name {
//            case "bottomRed":
//                bottomGradient.startColor = CCColor.redColor()
//            case "bottomOrange":
//                bottomGradient.startColor = CCColor.orangeColor()
//            case "bottomYellow":
//                bottomGradient.startColor = CCColor.yellowColor()
//            case "bottomGreen":
//                bottomGradient.startColor = CCColor.greenColor()
//            case "bottomCyan":
//                bottomGradient.startColor = CCColor.cyanColor()
//            case "bottomBlue":
//                bottomGradient.startColor = CCColor.blueColor()
//            case "bottomPurple":
//                bottomGradient.startColor = CCColor.purpleColor()
//            case "bottomMagenta":
//                bottomGradient.startColor = CCColor.magentaColor()
//            case "topRed":
//                topGradient.startColor = CCColor.redColor()
//            case "topOrange":
//                topGradient.startColor = CCColor.orangeColor()
//            case "topYellow":
//                topGradient.startColor = CCColor.yellowColor()
//            case "topGreen":
//                topGradient.startColor = CCColor.greenColor()
//            case "topCyan":
//                topGradient.startColor = CCColor.cyanColor()
//            case "topBlue":
//                topGradient.startColor = CCColor.blueColor()
//            case "topPurple":
//                topGradient.startColor = CCColor.purpleColor()
//            case "topMagenta":
//                topGradient.startColor = CCColor.magentaColor()
//            default:
//                println("nanananabooboobooboostickyourheadindoodoo")
//        }
//        
//        if buttonPressed.name.hasPrefix("bottom") {
//            bPickYourColor.visible = false
//            bNextButton.visible = true
//        } else if buttonPressed.name.hasPrefix("top") {
//            tPickYourColor.visible = false
//            tNextButton.visible = true
//        }
//    }
//}
