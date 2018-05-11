//
//  BSKConfiguration.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit

class BSKConfiguration {
    
    var textureNode: SKSpriteNode = SKSpriteNode()
    
    var numberOfGunBarrel: Int = 1
    
    var fireInterval: CFTimeInterval = 1.0
    
    var fireAccuracy: CGFloat = 1.0  // Ranged from 0.0 ~ 1.0, only applied to target-based pattern
    
    var gateControl: BSKGateControl = BSKGateControl(uptime: 0, downtime: 0)
    
    var bulletPattern: BSKPattern = .SingleDirectional
    
    var travelDistance: CGFloat = 0.0
    
    var travelDuration: CFTimeInterval = 0.0
    
    var visbileDelay: CFTimeInterval = 0.0 // Initial delay before bullets become visibile on the screen
}
