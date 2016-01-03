//
//  Bullet.swift
//  SI2
//
//  Created by George Dodwell on 1/1/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Cocoa
import SpriteKit

class Bullet: SKSpriteNode {
    
    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color:SKColor.clearColor(), size:texture.size())
        if (bulletSound != nil) {
            runAction(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
