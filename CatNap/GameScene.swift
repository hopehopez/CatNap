//
//  GameScene.swift
//  CatNap
//
//  Created by zsq on 2017/11/8.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Cat: UInt32 = 0b1 //1
    static let Block: UInt32 = 0b10 //2
    static let Bed: UInt32 = 0b100 //4
    static let Edge: UInt32 = 0b1000 //8
    static let Label: UInt32 = 0b10000 //16
}

protocol CustomNodeEvents {
    func didMoveToScene() 
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene {
    
    var bedNode: BedNode!
    var catNode: CatNode!
    var playable = true

    override func didMove(to view: SKView) {
        
        let maxAspectRatio: CGFloat = 16/9
        
        let maxAspectRatioHeight = size.width / maxAspectRatio
        
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        }
        
        bedNode = childNode(withName: "bed") as! BedNode
        catNode = childNode(withName: "//cat_body") as! CatNode
        
        SKTAudio.sharedInstance().playBackgroundMusic(filename: "backgroundMusic.mp3")
        
    }
    
    func inGameMessage(message: String) {
        let message = MessageNode(message: message)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    @objc func newGame() {
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
    
    func lose() {
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        run(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))
        
        inGameMessage(message: "Try again...")
        
        perform(#selector(newGame), with: nil, afterDelay: 5)
        
        catNode.wakeUp()
    }
    
    func win() {
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        run(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
        
        inGameMessage(message: "Nice job!")
        
        perform(#selector(newGame), with: nil, afterDelay: 3)

        catNode.curlAt(scenePoint: bedNode.position)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if !playable {
            return
        }
        
        let collsion = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collsion == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("scuccess")
            win()
        } else if collsion == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("fail")
            lose()
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
