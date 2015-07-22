//
//  ColorSelect.swift
//  Battle
//
//  Created by Derek Wrenn on 7/21/15.
//

import UIKit

class ColorSelect: CCNode {
   
    weak var bottomGradient: CCNodeGradient!
    weak var topGradient: CCNodeGradient!
    
    func changeColor(buttonPressed: CCButton) {
        switch buttonPressed.name {
            case "bottomRed":
                bottomGradient.startColor = CCColor.redColor()
            case "bottomOrange":
                bottomGradient.startColor = CCColor.orangeColor()
            case "bottomYellow":
                bottomGradient.startColor = CCColor.yellowColor()
            case "bottomGreen":
                bottomGradient.startColor = CCColor.greenColor()
            case "bottomCyan":
                bottomGradient.startColor = CCColor.cyanColor()
            case "bottomBlue":
                bottomGradient.startColor = CCColor.blueColor()
            case "bottomPurple":
                bottomGradient.startColor = CCColor.purpleColor()
            case "bottomMagenta":
                bottomGradient.startColor = CCColor.magentaColor()
            case "topRed":
                topGradient.startColor = CCColor.redColor()
            case "topOrange":
                topGradient.startColor = CCColor.orangeColor()
            case "topYellow":
                topGradient.startColor = CCColor.yellowColor()
            case "topGreen":
                topGradient.startColor = CCColor.greenColor()
            case "topCyan":
                topGradient.startColor = CCColor.cyanColor()
            case "topBlue":
                topGradient.startColor = CCColor.blueColor()
            case "topPurple":
                topGradient.startColor = CCColor.purpleColor()
            case "topMagenta":
                topGradient.startColor = CCColor.magentaColor()
            case "black":
                topGradient.endColor = CCColor.blackColor()
                bottomGradient.endColor = CCColor.blackColor()
            case "white":
                topGradient.endColor = CCColor.whiteColor()
                bottomGradient.endColor = CCColor.whiteColor()
            
            default:
                println("nanananabooboobooboostickyourheadindoodoo")
            
        }
        
    }
}
