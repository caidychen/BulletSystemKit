//
//  GameScene.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: BaseGameScene {

    var bulletSystemNode: BSKNode!
    private let enemy = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
    private let player = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
    
    lazy var bskConfig: BSKConfiguration = {
        let bskConfig = BSKConfiguration()
        bskConfig.textureNode = SKSpriteNode(imageNamed: "blueBullet.png")
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
        
        enemy.position = CGPoint(x: size.width / 2, y: size.height - 180)
        addChild(enemy)
        player.position = CGPoint(x: size.width / 2, y: 180)
        addChild(player)

        bulletSystemNode = BSKNode(with: bskConfig)
        bulletSystemNode.run(on: enemy, scene: self, targetNode: player)
        bulletSystemNode.zPosition = enemy.zPosition + 1
        frameDidUpdate = {[weak self](timeSinceLastUpdate, scene) in
            
        }
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
