//
//  bubble.swift
//  BoutThatBubble
//
//  Created by Jaeson Booker on 9/27/18.
//  Copyright © 2018 Jaeson Booker. All rights reserved.
//

import Foundation
import SpriteKit

class Bubble: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "bibble")
        let size = texture.size()
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 10)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")
    }
}
