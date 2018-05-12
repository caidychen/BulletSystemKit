//
//  GameScene.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Collision {
    static let playerBulletHitCategory: UInt32 = 1
    static let enemyBulletHitCategory: UInt32 = 2
    static let playerHitCategory: UInt32 = 3
    static let enemyHitCategory: UInt32 = 4
    
}

class GameScene: BaseGameScene {

    var bulletSystemNode: BSKNode!
    private let enemy = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    private let player = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
    
    lazy var bskConfig: BSKConfiguration = {
        let bskConfig = BSKConfiguration()
        bskConfig.textureNode = SKSpriteNode(imageNamed: "blueDiamond.png")
        bskConfig.numberOfGunBarrel = 20
        bskConfig.fireInterval = 0.1
        bskConfig.fireAccuracy = 1.0
        bskConfig.gateControl = BSKGateControl(uptime: 0.3, downtime: 0.5)
        bskConfig.bulletPattern = .ArcDirectional(fullAngle: 120)
        bskConfig.travelDistance = CGFloat(sqrtf(Float(size.width * size.width + size.height * size.height)))
        bskConfig.travelDuration = 5
        bskConfig.visbileDelay = 0.1
        return bskConfig
    }()
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        enemy.position = CGPoint(x: size.width / 2, y: size.height - 180)
        addChild(enemy)
        player.position = CGPoint(x: size.width / 2, y: 180)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody?.categoryBitMask = Collision.playerHitCategory
        player.physicsBody?.collisionBitMask = 0
        addChild(player)

        bulletSystemNode = BSKNode(with: bskConfig)
        bulletSystemNode.name = "BlueBullet"
        bulletSystemNode.categoryBitMask = Collision.enemyBulletHitCategory
        bulletSystemNode.contactTestBitMask = Collision.playerHitCategory
        bulletSystemNode.run(on: enemy, scene: self, targetNode: player)
        bulletSystemNode.zPosition = enemy.zPosition + 1
        frameDidUpdate = {[weak self](timeSinceLastUpdate, scene) in
            
        }
    }
    
    func clearAllBullets() {
        let allBullets = self.children.filter{$0.name == bulletSystemNode.name}
        removeChildren(in: allBullets)
    }
    
    func resetBSKSystem(){
        bulletSystemNode.stop()
        bulletSystemNode.run(on: enemy, scene: self, targetNode: player)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        enemy.position = enemy.position + touchMovedDelta
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if firstBody.categoryBitMask == Collision.playerHitCategory && secondBody.categoryBitMask == Collision.enemyBulletHitCategory {
            let enemyBullet = secondBody.node as! SKSpriteNode
            enemyBullet.removeAllActions()
            enemyBullet.removeFromParent()
           
        }
    }
}
