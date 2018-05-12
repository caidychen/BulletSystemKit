//
//  BSKNode.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit
import SceneKit

class BSKNode: SKNode {
    
    private weak var parentNode: SKSpriteNode?
    private weak var baseScene: SKScene?
    private weak var targetNode: SKSpriteNode?
    private(set) var running = false
    private var timeSinceLastBulletShoot: CFTimeInterval = 0
    private var gateOpen = false {
        didSet {
            if !gateOpen {
                runLoopCounter = 0
            }
        }
    }
    private var runLoopCounter = 0
    var categoryBitMask: UInt32 = 0
    var contactTestBitMask: UInt32 = 0
    var configuration: BSKConfiguration!
    
    init(with configuration: BSKConfiguration) {
        super.init()
        self.configuration = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run(on parentNode: SKSpriteNode, scene: SKScene, targetNode: SKSpriteNode){
        if running {
            return
        }
        self.gateOpen = false
        self.parentNode = parentNode
        self.baseScene = scene
        self.targetNode = targetNode
        running = true
        
        scheduleGateControl(scene: scene)
        scheduleFire(scene: scene)
        
    }
    
    private func scheduleGateControl(scene: SKScene) {
        if self.configuration.gateControl.downtime <= 0 {
            self.gateOpen = true
            return
        }
        parentNode!.run(configuration.gateControl.action {
            self.gateOpen = !self.gateOpen
        })
    }
    
    private func scheduleFire(scene: SKScene) {
        if self.configuration.fireInterval <= 0 {
            return
        }
        
        parentNode!.run(BSKFireInterval.action(interval: configuration.fireInterval){
            self.runloop(scene: scene)
        })
    }
    
    private func runloop(scene: SKScene) {
        if !gateOpen {return}
        guard let parentNode = parentNode else {return}
        guard let targetNode = targetNode else {return}
        
        let vectors = BSKBulletTrackConverter.getVectors(
            distance: configuration.travelDistance,
            currentPosition: parentNode.position,
            targetPosition: targetNode.position,
            pattern: configuration.bulletPattern,
            numberOfBullet: configuration.numberOfGunBarrel,
            accuracy: configuration.fireAccuracy
        )
        
        var bullietList: [SKSpriteNode] = []
        for _ in 0..<configuration.numberOfGunBarrel {
            bullietList.append(configuration.textureNode.copy() as! SKSpriteNode)
        }

        
        for (index, bulletNode) in bullietList.enumerated() {
            
            bulletNode.position = parentNode.position
            let action = SKAction.move(by: vectors[index] * (CGFloat(runLoopCounter) * (configuration.vectorAcceleration) + 1), duration: self.configuration.travelDuration)
            bulletNode.run(action, completion: {
                bulletNode.removeFromParent()
            })
            bulletNode.alpha = 0.0
            let visibleWait = SKAction.wait(forDuration: self.configuration.visbileDelay)
            let visibleBlock = SKAction.run({
                bulletNode.alpha = 1.0
            })
            let visibleSequence = SKAction.sequence([visibleWait,visibleBlock])
            bulletNode.run(visibleSequence)
            bulletNode.zPosition = zPosition
            bulletNode.zRotation = vectors[index].angle + CGFloat(Float.pi / 2)
            bulletNode.name = name
            bulletNode.physicsBody = SKPhysicsBody(rectangleOf: bulletNode.texture!.size())
            bulletNode.physicsBody?.categoryBitMask = categoryBitMask
            bulletNode.physicsBody?.contactTestBitMask = contactTestBitMask
            bulletNode.physicsBody?.collisionBitMask = 0
            scene.addChild(bulletNode)
        }
        runLoopCounter += 1
    }
    
    func stop(){
        running = false
        gateOpen = false
        parentNode!.removeAllActions()
    }
}
