//
//  BSKFireInterval.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 12/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit

class BSKFireInterval {

    static func action(interval: CFTimeInterval, block: @escaping (() -> Void)) -> SKAction {
        let wait = SKAction.wait(forDuration: interval)
        let action = SKAction.run({
            block()
        })
        let gateSequence = SKAction.sequence([action, wait])
        return SKAction.repeatForever(gateSequence)
    }
}
