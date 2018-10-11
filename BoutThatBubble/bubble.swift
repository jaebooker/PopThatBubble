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
    var image: String?
    var sizeType: String?
    init(image: String, sizeType: String?) {
        self.image = image
        self.sizeType = sizeType
        let texture = SKTexture(imageNamed: self.image!)
        var size = texture.size()
        //checks to see what size to make bubble
        if sizeType == "small" {
            size.width = size.width / 20
            size.height = size.height / 20
        } else if sizeType == "normal" {
            size.width = size.width / 10
            size.height = size.height / 10
        } else if sizeType == "big" {
            size.width = size.width / 5
            size.height = size.height / 5
        } else if sizeType == "extra big" {
            size.width = size.width / 3.5
            size.height = size.height / 3.5
        }
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")
    }
}
