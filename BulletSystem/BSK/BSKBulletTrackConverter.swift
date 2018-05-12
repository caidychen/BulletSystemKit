//
//  BSKBulletTrackConverter.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import SpriteKit

class BSKBulletTrackConverter {
    
    static func getVectors(distance: CGFloat,
                           currentPosition: CGPoint,
                           targetPosition: CGPoint,
                           pattern: BSKPattern,
                           numberOfBullet: Int,
                           accuracy: CGFloat) -> [CGVector] {
   
        var vectors: [CGVector] = []
        switch pattern {
            case .SingleDirectional:
                vectors = SingleDirectional.generateBulletVectors(capacity: numberOfBullet,
                                                                  currentPosition: currentPosition,
                                                                  targetPosition: targetPosition)
            case .Circular:
                vectors = Circular.generateBulletVectors(capacity: numberOfBullet,
                                                         currentPosition: currentPosition,
                                                         targetPosition: targetPosition)
            case .ArcDirectional(let fullAngle):
                vectors = ArcDirectional.generateBulletVectors(capacity: numberOfBullet,
                                                               currentPosition: currentPosition,
                                                               targetPosition: targetPosition,
                                                               fullAngle: fullAngle)
        }
        return vectors.enumerated().map({ (index, vector) -> CGVector in
            var vector = vector
            let variant = 1 - accuracy
            let vectorNoise = CGVector(dx: (CGFloat(arc4random_uniform(10)) - 5) * variant / 10,
                                       dy: (CGFloat(arc4random_uniform(10)) - 5) * variant / 10)
            let variantVector = variant == 0 ? vector.normalize() : vector.normalize() + vectorNoise
            return variantVector * (distance)
        })
    }
    
}
