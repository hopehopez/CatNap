//
//  BedNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/15.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, CustomNodeEvents {
    func didMoveToScene() {
        print("bed added to scene")
        
        let bedBodySize = CGSize(width: 40, height: 30)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.Bed
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
