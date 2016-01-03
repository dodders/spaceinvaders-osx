//
//  PlayerBullet.swift
//  SI2
//
//  Created by George Dodwell on 1/2/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Cocoa
import SpriteKit

class PlayerBullet: Bullet {
    
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = GameScene.CollisionCategories.PlayerBullet
        self.physicsBody?.contactTestBitMask = GameScene.CollisionCategories.Invader
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
