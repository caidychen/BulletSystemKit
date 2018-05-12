//
//  BSKPattern.swift
//  BulletSystem
//
//  Created by CHEN KAIDI on 9/5/18.
//  Copyright © 2018 CHEN KAIDI. All rights reserved.
//

import UIKit

enum BSKPattern {
    case SingleDirectional
    case ArcDirectional (fullAngle: CGFloat)
    case Circular
}

class SingleDirectional {
    static func generateBulletVectors(capacity: Int,
                                      currentPosition: CGPoint,
                                      targetPosition: CGPoint) -> [CGVector] {
        var vectors: [CGVector] = []
        for _ in 0..<capacity {
            let currentVector = CGVector(
                dx: targetPosition.x - currentPosition.x,
                dy: targetPosition.y - currentPosition.y
            )
            vectors.append(currentVector)
        }
        return vectors
    }
}

class ArcDirectional {
    static func generateBulletVectors(capacity: Int,
                                      currentPosition: CGPoint,
                                      targetPosition: CGPoint,
                                      fullAngle: CGFloat) -> [CGVector] {
        var vectors: [CGVector] = []
        for i in 0..<capacity {
            let angleInterval = fullAngle/CGFloat(capacity - 1)
            let aimAngle = CGVector(
                dx: targetPosition.x - currentPosition.x,
                dy: targetPosition.y - currentPosition.y
                ).angle.radiansToDegrees()
            let startAngle = aimAngle - fullAngle/2
            let currentVector = CGVector(angle: startAngle.degreesToRadians() + CGFloat(i)*angleInterval.degreesToRadians())
            vectors.append(currentVector)
        }
        return vectors
    }
}

class Circular {
    static func generateBulletVectors(capacity: Int,
                                      currentPosition: CGPoint,
                                      targetPosition: CGPoint) -> [CGVector]{
        var vectors: [CGVector] = []
        for i in 0..<capacity {
            let angleInterval = CGFloat(360) / CGFloat(capacity)
            let rotation: CGFloat = 90.0 - angleInterval
            let currentVector = CGVector(angle: angleInterval.degreesToRadians() * CGFloat(i) - rotation.degreesToRadians())
            vectors.append(currentVector)
        }
        return vectors
    }
}
