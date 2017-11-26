//
//  SpringNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/22.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {

    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250), at: CGPoint(x: size.width/2, y: size.height))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
            ]))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
