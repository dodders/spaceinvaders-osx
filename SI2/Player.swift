//
//  Player.swift
//  SI2
//
//  Created by George Dodwell on 1/1/16.
//  Copyright © 2016 George Dodwell. All rights reserved.
//

import Cocoa
import SpriteKit

class Player: SKSpriteNode {
    
    var canFire = true
    private var invincible = false
    private var lives:Int = 3 {
        didSet {
            if (lives < 0) {
                kill()
            } else {
                respawn()
            }
        }
    }
    
    func moveRight() {
        runAction(SKAction.moveByX(60.0, y: 0.0, duration: 0.1))
    }
    
    func moveLeft() {
        runAction(SKAction.moveByX(-60.0, y: 0.0, duration: 0.1))
    }
    
    init() {
        let texture = SKTexture(imageNamed: "player1")
        super.init(texture: texture, color:SKColor.clearColor(), size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = GameScene.CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = GameScene.CollisionCategories.Invader | GameScene.CollisionCategories.InvaderBullet
        self.physicsBody?.collisionBitMask = 0x0
        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate() {
        var playerTextures:[SKTexture] = []
        for i in 1...2 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let playerAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(playerTextures, timePerFrame: 0.1))
        self.runAction(playerAnimation)
    }
    
    func die() {
        if (self.invincible == false) {
            self.lives -= 1
        }
    }
    
    func kill() {
        NSLog("killed! todo.")
    }
    
    func respawn() {
        invincible = true
        let fadeOut = SKAction.fadeOutWithDuration(0.4)
        let fadeIn = SKAction.fadeInWithDuration(0.4)
        let fadeOutIn = SKAction.sequence([fadeOut, fadeIn])
        let fadeOutInRepeat = SKAction.repeatAction(fadeOutIn, count: 5)
        let setInvincibleFalse = SKAction.runBlock({
                self.invincible = false
        })
        runAction(SKAction.sequence([fadeOutInRepeat, setInvincibleFalse]))
    }
    
    func fireBullet(scene: SKScene) {
        if (canFire) {
            canFire = false
            let bullet = PlayerBullet(imageName: "laser", bulletSound: nil)
            bullet.position.x = self.position.x
            bullet.position.y = self.position.y + self.size.height / 2
            scene.addChild(bullet)
            let moveBulletAction = SKAction.moveTo(CGPoint(x:self.position.x, y:scene.size.height + bullet.size.height), duration: 1.0)
            let removeBulletAction = SKAction.removeFromParent()
            bullet.runAction(SKAction.sequence([moveBulletAction, removeBulletAction]))
            let waitToFire = SKAction.waitForDuration(0.1)
            runAction(waitToFire, completion: { self.canFire = true })
        }
        
    }

}
