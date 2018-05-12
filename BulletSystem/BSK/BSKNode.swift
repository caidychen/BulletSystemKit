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
        let uptime = SKAction.wait(forDuration: self.configuration.gateControl.uptime)
        let downtime = SKAction.wait(forDuration: self.configuration.gateControl.downtime)
        let gateControlBlock = SKAction.run({[unowned self] in
            self.gateOpen = !self.gateOpen
        })
        let gateSequence = SKAction.sequence([gateControlBlock, uptime, gateControlBlock, downtime])
        parentNode!.run(SKAction.repeatForever(gateSequence))
    }
    
    private func scheduleFire(scene: SKScene) {
        if self.configuration.fireInterval <= 0 {
            return
        }
        let shootWait = SKAction.wait(forDuration: self.configuration.fireInterval)
        let shootBlock = SKAction.run({[unowned self] in
            self.runloop(scene: scene)
        })
        let shootSequence = SKAction.sequence([shootWait,shootBlock])
        parentNode!.run(SKAction.repeatForever(shootSequence))
    }
    
    private func runloop(scene: SKScene) {
        if !gateOpen {return}
        guard let parentNode = parentNode else {return}
        guard let targetNode = targetNode else {return}
        
        print("Run loop counter: \(runLoopCounter)")
        let vectors = BSKBulletTrackConverter.getVectors(
            distance: configuration.travelDistance,
            currentPosition: parentNode.position,
            targetPosition: targetNode.position,
            pattern: configuration.bulletPattern,
            numberOfBullet: configuration.numberOfGunBarrel,
            accuracy: configuration.fireAccuracy
        )
        var bulletNodeList: [SKSpriteNode] = []
        for _ in 0..<configuration.numberOfGunBarrel {
            bulletNodeList.append(configuration.textureNode.copy() as! SKSpriteNode)
        }

        for (index, bulletNode) in bulletNodeList.enumerated() {
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
