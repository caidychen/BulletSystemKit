//
//  BSKBulletTrackConverter.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit

class BSKBulletTrackConverter {
    
    static func getVectors(distance: CGFloat, currentPosition: CGPoint, targetPosition: CGPoint, pattern: BSKPattern, numberOfBullet: Int, accuracy: CGFloat) -> [CGVector] {
   
        var vectors: [CGVector] = []
        for i in 0..<numberOfBullet {
            
            switch pattern {
            case .SingleDirectional:
                let movement = CGVector(
                    dx: targetPosition.x - currentPosition.x,
                    dy: targetPosition.y - currentPosition.y
                )
                vectors.append(movement)
                continue
            case .Circular:
                let angleInterval = CGFloat(360) / CGFloat(numberOfBullet)
                let rotation: CGFloat = 90.0 - angleInterval
                let vector = CGVector(angle: angleInterval.degreesToRadians() * CGFloat(i) - rotation.degreesToRadians())
                vectors.append(vector)
                continue
            case .ArcDirectional(let fullAngle):
                let angleInterval = fullAngle/CGFloat(numberOfBullet - 1)
                let aimAngle = CGVector(
                    dx: targetPosition.x - currentPosition.x,
                    dy: targetPosition.y - currentPosition.y
                ).angle.radiansToDegrees()
                let startAngle = aimAngle - fullAngle/2
                let currentVector = CGVector(angle: startAngle.degreesToRadians() + CGFloat(i)*angleInterval.degreesToRadians())
                vectors.append(currentVector)
                continue
            default:
                break
            }
        }
        return vectors.map({ (vector) -> CGVector in
            var vector = vector
            let variant = 1 - accuracy
            let variantVector = variant == 0 ?
                vector.normalize() :
                vector.normalize() + CGVector(dx: (CGFloat(arc4random_uniform(10)) - 5)*variant / 10, dy: (CGFloat(arc4random_uniform(10)) - 5)*variant / 10)
            return variantVector * distance
        })
    }
    
}
