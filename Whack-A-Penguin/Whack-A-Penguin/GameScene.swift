//
//  GameScene.swift
//  Whack-A-Penguin
//
//  Created by Jelani Denis on 7/6/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var numRounds = 0

    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var slots = [WhackSlot]()
    
    var popupTime = 0.85

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self]  in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            for node in nodes {
                
                //ensure this is a charNode
                guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
                if !whackSlot.isVisible || whackSlot.isHit { continue }
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                whackSlot.hit()
                
                //update score & sound based on char type
                if node.name == "charEnemy" {
                    score += 1
                    run(SKAction.playSoundFileNamed("whackGood.caf", waitForCompletion:false))

                } else if node.name == "charFriend" {
                    score -= 5
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
                }
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        if numRounds >= 30 { gameOver() }
        
        slots.shuffle()
        
        //show up to 5 random penguins
        slots[0].show(hideTime: popupTime)
        for i in 1...4 {
            var random = Int.random(in: 1...12)
            if i == 4 { random = Int.random(in: 1...24)}
            if random > i * 3 { slots[i].show(hideTime: popupTime) }
        }
        
        //randomly update wait time
        let random = Double.random(in: popupTime / 2 ... popupTime * 4)
        DispatchQueue.main.asyncAfter(deadline: .now() + random) {
            [weak self]  in
            self?.createEnemy()
        }
        
        //gradually decrease popupTime
        popupTime *= 0.991
        
    }
    
    func gameOver() {
        for slot in slots {
            slot.hide()
        }

        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)

        return
    }
    
}
