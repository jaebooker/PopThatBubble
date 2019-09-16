//
//  GameScene.swift
//  BoutThatBubble
//
//  Created by Jaeson Booker on 9/27/18.
//  Copyright © 2018 Jaeson Booker. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    //create background music object
//    let backgroundSound = SKAudioNode(fileNamed: "Raven&KreynCopyrightFreeMusic.mp3")
    var musicForGame = Bundle.main.path(forResource: "Raven&KreynCopyrightFreeMusic", ofType: "mp3")!
    //"Raven&KreynCopyrightFreeMusic"
    //"Royalty Free Heavy Metal Instrumental - Game Over (Creative Commons)"
    var backgroundMusicPlayer = AVAudioPlayer()
    //set score
    var score: Int = 0
    //set initial bubble speed
    var bubbleSpeedCount: Double = 10.0
    //set counter for bubbles
    var bubbleCount: Int = 0
    var soundSwitch: Int = 0
    func createBubble(name: String, image: String, bubbleSpeed: Double, sizeType: String) {
        let bubble: Bubble = Bubble(image: image, sizeType: sizeType)
        bubble.name = name
        bubble.physicsBody?.isDynamic = true
        bubble.physicsBody?.affectedByGravity = false
        bubble.position.x = 425
        bubble.position.y = CGFloat.random(in: Range<CGFloat>(uncheckedBounds: (lower: -627.0, upper: 627.0)))
        addChild(bubble)
        bubbleCount += 1
        moveThatBubble(bubble: bubble, bubbleSpeed: bubbleSpeed)
    }
    func moveThatBubble(bubble: Bubble, bubbleSpeed: Double) {
        let moveUp = SKAction.moveBy(x: -1000,
                                     y: 0,
                                     duration: bubbleSpeed)
        let removeNode = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveUp, removeNode])
        bubble.run(sequence)
    }
    override func didMove(to view: SKView) {
//        self.addChild(backgroundSound)
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicForGame))
        }
        catch {
            print(error)
        }
        backgroundMusicPlayer.play()
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "scoreCard") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "\(score)"
        }
        createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount, sizeType: "normal")
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
            //create bubble sound node
            var bubbleSound: SKAudioNode
            //toggle soundSwitch, so sound has some variability
            if soundSwitch == 0 {
                bubbleSound = SKAudioNode(fileNamed: "drumSnare1.mp3")
                soundSwitch = 1
            } else {
                bubbleSound = SKAudioNode(fileNamed: "drumSnare2.wav")
                soundSwitch = 0
            }
            //prevents soundeffect from playing more than one time per use
            bubbleSound.autoplayLooped = false
            addChild(bubbleSound)
            //runs a sequence for the sound effect, setting duration of sound
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
            //increase speed with each bubble popped
            bubbleSpeedCount -= 0.25
            label!.text = "\(score)"
            //create two more bubbles to replace the one destroyed
            createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount, sizeType: "normal")
            createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount, sizeType: "normal")
            bubbleCount -= 1
            //creates a few red bubbles
            if score % 3 == 0 {
                createBubble(name: "redBubble", image: "redBubble", bubbleSpeed: bubbleSpeedCount, sizeType: "normal")
            }
            //creates faster gold bubbles
            if score % 5 == 0 {
                createBubble(name: "goldBubble", image: "goldBubble", bubbleSpeed: bubbleSpeedCount - 3, sizeType: "extra big")
            }
            //creates smaller, not as fast gold bubbles
            if score % 10 == 0 {
                createBubble(name: "goldBubble", image: "goldBubble", bubbleSpeed: bubbleSpeedCount - 2, sizeType: "big")
            }
        } else if atPoint(location).name == "redBubble" {
            //red bubbles are smaller, so are worth more points
            score += 5
            label!.text = "\(score)"
            let redBubbleSound = SKAudioNode(fileNamed: "siren.mp3")
            redBubbleSound.autoplayLooped = false
            addChild(redBubbleSound)
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    // this will start playing the sound
                    redBubbleSound.run(SKAction.play())
                }]))
            atPoint(location).removeFromParent()
            //creates smaller blue bubbles, at a slower speed
            createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount + 1, sizeType: "small")
            createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount + 1, sizeType: "small")
            //slows the overall speed slightly
            bubbleSpeedCount += 0.25
        } else if atPoint(location).name == "goldBubble" {
            //gold bubbles are faster, and rare, so they are worth much more
            score += 20
            label!.text = "\(score)"
            let redBubbleSound = SKAudioNode(fileNamed: "siren.mp3")
            redBubbleSound.autoplayLooped = false
            addChild(redBubbleSound)
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    // this will start playing the sound
                    redBubbleSound.run(SKAction.play())
                }]))
            atPoint(location).removeFromParent()
            //gold bubbles create larger, faster red bubbles
            createBubble(name: "redBubble", image: "redBubble", bubbleSpeed: bubbleSpeedCount - 3, sizeType: "big")
            createBubble(name: "redBubble", image: "redBubble", bubbleSpeed: bubbleSpeedCount - 3, sizeType: "big")
            //gold bubbles slow the overall speed slightly
            bubbleSpeedCount += 0.5
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
        var bubbleCheck = false
        //checks if there are bubbles in the game
        enumerateChildNodes(withName: "bubble") { indicatorNode, _ in
            bubbleCheck = true
        }
        //if there are no bubbles left, restarts game
        if !bubbleCheck {
            let siren = SKAudioNode(fileNamed: "siren2.mp3")
            siren.autoplayLooped = false
            addChild(siren)
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.run {
                    // this will start playing the sound
                    siren.run(SKAction.play())
                }]))
            //resets score
            score = 0
            label!.text = "\(score)"
            backgroundMusicPlayer.stop()
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicForGame))
            }
            catch {
                print(error)
            }
            backgroundMusicPlayer.play()
//            backgroundSound.removeFromParent()
//            addChild(backgroundSound)
            //resets speed
            bubbleSpeedCount = 10
            bubbleCount = 0
            createBubble(name: "bubble", image: "bibble", bubbleSpeed: bubbleSpeedCount, sizeType: "normal")
        }
    }
}
