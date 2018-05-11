//
//  BaseGameScene.swift
//  ShmupTest
//
//  Created by CHEN KAIDI on 5/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import GameplayKit

class BaseGameScene: SKScene {
    private let frameRate: Double = 60.0
    var previousUserTouch = CGPoint.zero
    var lastUpdateTime: CFTimeInterval = 0  // Time when update() was last called
    var touchMovedDelta: CGPoint = .zero
    var frameDidUpdate: ((CFTimeInterval, SKScene) -> Void)?
    
    private var userDragging = false
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var timeSinceLastUpdate = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1.0 / frameRate
            lastUpdateTime = currentTime
        }
        frameDidUpdate?(timeSinceLastUpdate, self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if userDragging {
            return
        }
        previousUserTouch = touches.first?.location(in: self) ?? .zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first?.location(in: self) ?? .zero
        let deltaX = touch.x - previousUserTouch.x
        let deltaY = touch.y - previousUserTouch.y
        touchMovedDelta = CGPoint(x: deltaX, y: deltaY)
        previousUserTouch = touch
        userDragging = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        userDragging = false
    }
}


