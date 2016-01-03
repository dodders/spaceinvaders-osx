//
//  LevelCompleteScene.swift
//  SI2
//
//  Created by George Dodwell on 1/3/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Cocoa
import SpriteKit

class LevelCompleteScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        let btn = SKSpriteNode(imageNamed: "nextlevelbtn")
        btn.position = CGPointMake(size.width/2, size.height/2 - btn.size.height/2)
        btn.name = "nextLevel"
        addChild(btn)
    }
    
    @IBAction func buttonTapped(button: NSButton) {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = self.scaleMode
        let trans = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(gameScene, transition: trans)
    }

}
