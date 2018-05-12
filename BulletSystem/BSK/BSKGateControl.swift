//
//  BSKGateControl.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit

struct BSKGateControl {
    var uptime: CFTimeInterval
    var downtime: CFTimeInterval
    
    func action(block: @escaping (() -> Void)) -> SKAction {
        let uptime = SKAction.wait(forDuration: self.uptime)
        let downtime = SKAction.wait(forDuration: self.downtime)
        let gateControlBlock = SKAction.run({
            block()
        })
        let gateSequence = SKAction.sequence([gateControlBlock, uptime, gateControlBlock, downtime])
        return SKAction.repeatForever(gateSequence)
    }
}
