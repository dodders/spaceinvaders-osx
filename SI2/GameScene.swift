//
//  GameScene.swift
//  SI2
//
//  Created by George Dodwell on 1/1/16.
//  Copyright (c) 2016 George Dodwell. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var invaderNum = 1
    let invaderRows = 4
    let maxLevels = 3
    var invaderSpeed = 2
    let leftBound = CGFloat(30)
    var rightBound = CGFloat(0)
    var firers:[Invader] = []
    let player = Player()
    var invHits = 0
    var invaders:[Invader] = []
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.physicsWorld.contactDelegate = self
        rightBound = self.size.width - 30
        setUpInvaders()
        setUpPlayer()
        invaderFire()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == CollisionCategories.Invader) &&
            (secondBody.categoryBitMask == CollisionCategories.PlayerBullet)){
                if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                    return
                }
                doInvaderHit(firstBody.node!, secondNode: secondBody.node!)
        }
        
        if ((firstBody.categoryBitMask == CollisionCategories.Player) &&
            (secondBody.categoryBitMask == CollisionCategories.InvaderBullet)) {
                player.die()
        }
        
        if ((firstBody.categoryBitMask == CollisionCategories.Invader) &&
            (secondBody.categoryBitMask == CollisionCategories.Player)) {
                player.kill()
        }
    }
    
    func doInvaderHit(node: SKNode, secondNode: SKNode) {
        let inv = node as! Invader
        let newInvRow = inv.row - 1
        let newCol = inv.col
        if (newInvRow >= 1) {
            self.enumerateChildNodesWithName("invader", usingBlock: {node, stop in
                let invader = node as! Invader
                if (invader.row == newInvRow && invader.col == newCol) {
                    self.firers.append(invader)
                    stop.memory = true
                }
                let invIndex = self.findIndex(self.firers, valueToFind: node)
                if (invIndex != nil) {
                    self.firers.removeAtIndex(invIndex!)
                }
            })
        }
        inv.removeFromParent()
        secondNode.removeFromParent()
        let invIndex = self.findIndex(invaders, valueToFind: inv)
        if (invIndex != nil) {
            invaders.removeAtIndex(invIndex!)
        }
        if (invaders.isEmpty) {
            levelComplete()
        }
    }
    
    func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
        for (index, value) in array.enumerate() {
            if (value == valueToFind) {
                return index
            }
        }
        return nil
    }
    
    override func keyDown(theEvent: NSEvent) {
        switch (theEvent.keyCode) {
            case 126: upArrow(theEvent)
            case 123: leftArrow(theEvent)
            case 124: rightArrow(theEvent)
            default: break
        }
    }
    
    struct CollisionCategories {
        static let Invader: UInt32 = 0x1 << 0
        static let Player: UInt32 = 0x1 << 1
        static let InvaderBullet: UInt32 = 0x1 << 2
        static let PlayerBullet: UInt32 = 0x1 << 3
    }
    
    func upArrow(event: NSEvent) {
        player.fireBullet(self)
    }
    
    func rightArrow(event: NSEvent) {
        player.moveRight()
    }

    func leftArrow(event: NSEvent) {
        player.moveLeft()
    }
    
    func invaderFire() {
        let fireBullet = SKAction.runBlock({
            self.fireInvaderBullet()
        })
        let waitToFire = SKAction.waitForDuration(1.5)
        let invaderFire = SKAction.sequence([fireBullet, waitToFire])
        let repeatForever = SKAction.repeatActionForever(invaderFire)
        runAction(repeatForever)
    }
    
    func fireInvaderBullet() {
        if (firers.isEmpty) {
            levelComplete()
        } else {
            let random = firers.randomElement()
            random.fireBullet(self)
        }
    }
    
    func levelComplete() {
        let completeScene = LevelCompleteScene(size: self.size)
        completeScene.scaleMode = self.scaleMode
        let trans = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(completeScene, transition: trans)
    }
    
    func moveInvaders() {
        var changeDir = false
        self.enumerateChildNodesWithName("invader", usingBlock: { node, stop in
            let inv = node as! SKSpriteNode
            let invHWidth = inv.size.width/2
            inv.position.x -= CGFloat(self.invaderSpeed)
            if (inv.position.x > self.rightBound - invHWidth || inv.position.x < self.leftBound + invHWidth) {
                changeDir = true
            }
        
            if (changeDir) {
                self.invaderSpeed *= -1
                self.enumerateChildNodesWithName("invader", usingBlock: { node, stop in
                    let inv = node as! SKSpriteNode
                    inv.position.y -= CGFloat(46)
                    })
            }
            changeDir = false
        })
    }
    
    override func update(currentTime: CFTimeInterval) {
        moveInvaders()
    }
    
    override func mouseDown(theEvent: NSEvent) {
    }
    
    func setUpPlayer() {
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:player.size.height/2 + 10)
        addChild(player)
    }
    
    func setUpInvaders() {
        var row = 0
        var col = 0
        let num = invaderNum * 2 + 1
        for var i = 1; i <= invaderRows; i++ {
            row = i
            for var j = 1; j <= num; j++ {
                col = j
                let inv: Invader = Invader()
                let invHalfWidth:CGFloat = inv.size.width/2
                let xPosStart:CGFloat = size.width/2 - invHalfWidth - (CGFloat(num) * inv.size.width) + CGFloat(10)
                inv.position = CGPoint(x:xPosStart + ((inv.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46))
                inv.row = row
                inv.col = col
                addChild(inv)
                if (i == invaderRows) {
                    firers.append(inv)
                }
                invaders.append(inv)
            }
        }
    }
}
