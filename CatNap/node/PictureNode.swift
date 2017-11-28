//
//  PictureNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/27.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit

class PictureNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    func interact() {
        isUserInteractionEnabled = false
        physicsBody?.isDynamic = true
    }
    

    func didMoveToScene() {
        isUserInteractionEnabled = true
        let pictureNode = SKSpriteNode(imageNamed: "picture")
        let maskNode = SKSpriteNode(imageNamed: "picture-frame-mask")
        
        let cropNode = SKCropNode()
        cropNode.addChild(pictureNode)
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        interact()
    }
}
