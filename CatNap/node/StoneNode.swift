//
//  StoneNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/26.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit

class StoneNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {

    func didMoveToScene() {
        let levelScene = scene
        
        if parent == levelScene {
            levelScene!.addChild(StoneNode.makeCompoundNode(inScene: levelScene!))
        }
        
    }
    
    func interact() {
        isUserInteractionEnabled = false
        run(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    static func makeCompoundNode(inScene scene: SKScene) -> SKNode {
        let compound = StoneNode()
        compound.zPosition = -1
        
        for stone in scene.children.filter({ (node) -> Bool in
            return node is StoneNode
        }) {
            stone.removeFromParent()
            compound.addChild(stone)
        }
        
        let bodies = compound.children.map { (node) -> SKPhysicsBody in
            SKPhysicsBody(rectangleOf: node.frame.size, center: node.position)
        }
        compound.physicsBody = SKPhysicsBody(bodies: bodies)
        compound.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Cat | PhysicsCategory.Block
        compound.physicsBody?.categoryBitMask = PhysicsCategory.Block
        compound.isUserInteractionEnabled = true
        compound.zPosition = 1
        return compound
        
    }
}
