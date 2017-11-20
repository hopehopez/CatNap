//
//  BlockNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/20.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {

    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        run(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.scale(to: 0.8, duration: 0.1),
            SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("destroy block")
        interact()
    }
}
