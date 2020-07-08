//
//  WhackSlot.swift
//  Whack-A-Penguin
//
//  Created by Jelani Denis on 7/6/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        if (Int.random(in: 0...2) > 0) {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }
        
        let show = SKAction.moveBy(x: 0, y: 80, duration: 0.05)
        charNode.run(show)
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 * hideTime) {
            [weak self]  in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        let hide = SKAction.moveBy(x: 0, y: 80, duration: 0.05)
        charNode.run(hide)
        isVisible = false
    }
    
    func hit() {
        if !isVisible { return }

        isHit = true
        // an unowned reference is one you're certifying cannot be nil
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }

}
