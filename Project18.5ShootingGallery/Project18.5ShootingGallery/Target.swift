//
//  Target.swift
//  Project18.5ShootingGallery
//
//  Created by Connor Lee on 20/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import SpriteKit
import UIKit

class Target: SKNode {
    var stickNode: SKSpriteNode!
    var targetNode: SKSpriteNode!
    
    func configure() {
        let stickNumber = Int.random(in: 0...2)
        let targetNumber = Int.random(in: 0...3)
        
        stickNode = SKSpriteNode(imageNamed: "stick\(stickNumber)")
        targetNode = SKSpriteNode(imageNamed: "target\(targetNumber)")
        
        targetNode.name = "target"
        if targetNumber == 3 {
            targetNode.name = "bad"
        }
        targetNode.position.y += 116
        
        addChild(stickNode)
        addChild(targetNode)
    }
    
    func hit() {
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let sequence = SKAction.sequence([delay, hide])
        run(sequence)
    }
}
