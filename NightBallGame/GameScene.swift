//
//  GameScene.swift
//  NightBallGame
//
//  Created by Danny Lan on 2017-08-15.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Add ball image
    let ball = SKSpriteNode(imageNamed: "Nightball - Circle")

    override func didMove(to view: SKView) {
        
        // Set background colour to black
        backgroundColor = SKColor.black
        
        // MAIN BALL
        
        // Ball position
        ball.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        // Resize ball
        ball.scale(to: CGSize(width: 200, height: 200))
        // Adding actual ball
        addChild(ball)
        
        // Generate projectiles
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addProjectile),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }
    
    //CREATE PROJECTILES
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addProjectile() {
        
        // Create sprite
        let projectile = SKSpriteNode(imageNamed: "projectile")
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: projectile.size.height/2, max: size.height - projectile.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        projectile.position = CGPoint(x: size.width + projectile.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(projectile)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -projectile.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
}
