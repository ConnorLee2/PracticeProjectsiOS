//
//  GameScene.swift
//  Project18.5ShootingGallery
//
//  Created by Connor Lee on 20/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimerLabel: SKLabelNode!
    var gameTimer: Timer?
    var timeInterval = 1.0
    var secondsRemaining = 60 {
        didSet {
            gameTimerLabel.text = "Time remaining: \(secondsRemaining)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ammoTextures = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3"),
    ]
    
    var ammoLabel1: SKSpriteNode!
    var ammoLabel2: SKSpriteNode!
    var ammo1 = 3 {
        didSet {
            ammoLabel1.texture = ammoTextures[ammo1]
        }
    }
    var ammo2 = 3 {
        didSet {
            ammoLabel2.texture = ammoTextures[ammo2]
        }
    }
    
    var enemiesCreated = 0
    var popupTime = 0.85
    var targetSpeed = 4.0
    
    override func didMove(to view: SKView) {
        createOverlay(screenSize: view.frame.size)
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createTarget()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
    
        for node in tappedNodes {
            guard let target = node.parent as? Target else { continue }
            target.hit()
            if node.name == "target" {
                score += 1
                target.setScale(0.85)
                target.setScale(0.85)
            } else if node.name == "bad" {
                score -= 5
            }
        }
    }
    
    func createOverlay(screenSize: CGSize) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.size = screenSize
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let grassTrees = SKSpriteNode(imageNamed: "grass-trees")
        grassTrees.size.width = screenSize.width
        grassTrees.position = CGPoint(x: 512, y: 384)
        grassTrees.zPosition = 100
        addChild(grassTrees)
        
        let waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.size.width = screenSize.width
        waterBg.position = CGPoint(x: 512, y: 180)
        waterBg.zPosition = 200
        addChild(waterBg)
        
        animateWater(water: waterBg, by: 100)
        
        let waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.size.width = screenSize.width
        waterFg.position = CGPoint(x: 512, y: 120)
        waterFg.zPosition = 300
        addChild(waterFg)
        
        animateWater(water: waterFg, by: -100)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.size = screenSize
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = 400
        addChild(curtains)
        
        gameTimerLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameTimerLabel.position = CGPoint(x: 8, y: 724)
        gameTimerLabel.horizontalAlignmentMode = .left
        gameTimerLabel.fontSize = 48
        gameTimerLabel.zPosition = 500
        addChild(gameTimerLabel)
        secondsRemaining = 60
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 100, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        scoreLabel.zPosition = 500
        addChild(scoreLabel)
        score = 0
        
        ammoLabel1 = SKSpriteNode(imageNamed: "shots3")
        ammoLabel1.position = CGPoint(x: 900, y: 24)
        ammoLabel1.zPosition = 500
        addChild(ammoLabel1)
        ammo1 = 3
        
        ammoLabel2 = SKSpriteNode(imageNamed: "shots3")
        ammoLabel2.position = CGPoint(x: 815, y: 24)
        ammoLabel2.zPosition = 500
        addChild(ammoLabel2)
        ammo2 = 3
    }
    
    func animateWater(water: SKSpriteNode,by direction: CGFloat) {
        let moveForward = SKAction.moveBy(x: direction, y: 0, duration: 1.0)
        let moveBackward = moveForward.reversed()
        let sequence = SKAction.sequence([moveForward, moveBackward])
        let repeatForever = SKAction.repeatForever(sequence)
        water.run(repeatForever)
    }
    
    @objc func updateTimer() {
        secondsRemaining -= 1
        
        if secondsRemaining == 0 {
            // Game over
            gameTimer?.invalidate()
            let gameOver = SKSpriteNode(imageNamed: "game-over")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 600
            addChild(gameOver)
        }
    }
    
    func createTarget() {
        if secondsRemaining <= 0 {
            // stop making if 0
            
            return
        }
        
        let target = Target()
        target.configure()
        
        let row = Int.random(in: 0...2)
        var movingRight = true
        
        switch (row) {
        case 0:
            // top row, front of grass
            target.position.y = 400
            target.zPosition = 75
            target.setScale(0.7)
        case 1:
            // mid row, water bg
            target.position.y = 190
            target.zPosition = 200
            target.setScale(0.85)
            movingRight = false
        default:
            // bottom row, water fg
            target.position.y = 100
            target.zPosition = 350
        }
        
        let move: SKAction
        targetSpeed *= 0.991
        
        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 1100, duration: targetSpeed)
        } else {
            target.position.x = 1000
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: targetSpeed)
        }

        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        target.run(sequence)
        
        addChild(target)
        
        popupTime *= 0.991
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createTarget()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
