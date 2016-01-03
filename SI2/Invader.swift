//
//  Invader.swift
//  SI2
//
//  Created by George Dodwell on 1/1/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Cocoa
import SpriteKit

class Invader: SKSpriteNode {
    
    var row = 0;
    var col = 0;
    
    init() {
        let texture = SKTexture(imageNamed: "invader1")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "invader"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = GameScene.CollisionCategories.Invader
        self.physicsBody?.contactTestBitMask = GameScene.CollisionCategories.PlayerBullet | GameScene.CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fireBullet(scene: SKScene) {
        let bullet = InvaderBullet(imageName: "laser", bulletSound: nil)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y - self.size.height / 2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.moveTo(CGPoint(x: self.position.x, y: 0 - bullet.size.height), duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([moveBulletAction, removeBulletAction]))
    }

}
