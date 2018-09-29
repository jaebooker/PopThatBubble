//
//  GameScene.swift
//  BoutThatBubble
//
//  Created by Jaeson Booker on 9/27/18.
//  Copyright © 2018 Jaeson Booker. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let backgroundSound = SKAudioNode(fileNamed: "bubbleMusic.mp3")
    var score: Int = 0
    var bubbleSpeed: Double = 10.0
    var bubbleCount: Int = 0
    var soundSwitch: Int = 0
    func createBubble() {
        let bubble: Bubble = Bubble()
        bubble.name = "bubble"
        bubble.physicsBody?.isDynamic = true
        bubble.physicsBody?.affectedByGravity = false
        bubble.position.x = 425
        bubble.position.y = CGFloat.random(in: Range<CGFloat>(uncheckedBounds: (lower: -627.0, upper: 627.0)))
        addChild(bubble)
        bubbleCount += 1
        moveThatBubble(bubble: bubble)
    }
    func moveThatBubble(bubble: Bubble) {
        let moveUp = SKAction.moveBy(x: -1000,
                                     y: 0,
                                     duration: bubbleSpeed)
        let removeNode = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveUp, removeNode])
        bubble.run(sequence)
    }
    override func didMove(to view: SKView) {
        self.addChild(backgroundSound)
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "scoreCard") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "\(score)"
        }
        createBubble()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //find out if screen was touched on the bubble
        if atPoint(location).name == "bubble" {
            var bubbleSound: SKAudioNode
            if soundSwitch == 0 {
                bubbleSound = SKAudioNode(fileNamed: "drumSnare1.mp3")
                soundSwitch = 1
            } else {
                bubbleSound = SKAudioNode(fileNamed: "drumSnare2.wav")
                soundSwitch = 0
            }
            bubbleSound.autoplayLooped = false
            addChild(bubbleSound)
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    // this will start playing the sound
                    bubbleSound.run(SKAction.play())
                }]))
            atPoint(location).removeFromParent()
//            let sound = SKAudioNode(fileNamed: "drum_snare1.wav")
//            addChild(sound)
//            let removeSound = sound.removeFromParent()
            score += 1
            bubbleSpeed -= 0.25
            label!.text = "\(score)"
            createBubble()
            createBubble()
            bubbleCount -= 1
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
