//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by zsq on 2017/11/27.
//  Copyright © 2017年 zsq. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, CustomNodeEvents, InteractiveNode{

    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    private var isDiscoTime: Bool = false {
        didSet{
            video.isHidden = !isDiscoTime
            
            if isDiscoTime {
                video.play()
                run(spinAction)
                SKTAudio.sharedInstance().playBackgroundMusic(filename: "disco-sound.m4a")
                video.run(SKAction.wait(forDuration: 5.0), completion: {
                    self.isDiscoTime = false
                })
            } else {
                video.pause()
                removeAllActions()
                SKTAudio.sharedInstance().playBackgroundMusic(filename: "backgroundMusic.mp3")
            }
            
            DiscoBallNode.isDiscoTime = isDiscoTime
        }
    }
    private let spinAction = SKAction.repeatForever(
        SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "discoball1")),
            SKTexture(image: #imageLiteral(resourceName: "discoball2")),
            SKTexture(image: #imageLiteral(resourceName: "discoball3"))
            ], timePerFrame: 0.2)
    )
    
    static private(set) var isDiscoTime = false
    
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let fileUrl = Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")
        player = AVPlayer(url: fileUrl!)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        video.zPosition = -1
        video.alpha = 0.75
        video.isHidden = true
        video.pause()
        
        scene?.addChild(video)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didReachEndOfVideo() {
        print("rewind")
        player.currentItem?.seek(to: kCMTimeZero)
    }
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
