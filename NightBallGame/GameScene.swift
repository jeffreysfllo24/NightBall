//
//  GameScene.swift
//  NightBallGame
//
//  Created by Danny Lan on 2017-08-15.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

// Set physics constraints
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let quadrantRed: UInt32 = 0b1
    static let quadrantGreen: UInt32 = 0b10
    static let quadrantBlue: UInt32 = 0b11
    static let quadrantYellow: UInt32 = 0b100
    static let star: UInt32 = 0b101
    
}
    class GameScene: SKScene,SKPhysicsContactDelegate {
    
        // Adding the center node which the nightball will rotate around (essentially acts as an anchor point)
        let centerNode: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball - Circle")
        // Adding the quadrants of the nightball
        let quadrantRed: SKSpriteNode = SKSpriteNode(imageNamed: "Quadrant-TR-Red")
        let quadrantGreen: SKSpriteNode = SKSpriteNode(imageNamed: "Quadrant-TL-Green")
        let quadrantBlue: SKSpriteNode = SKSpriteNode(imageNamed: "Quadrant-BR-Blue")
        let quadrantYellow: SKSpriteNode = SKSpriteNode(imageNamed: "Quadrant-BL-Yellow")
        
        let moon: SKSpriteNode = SKSpriteNode(imageNamed: "Moon")
        
        override func didMove(to view: SKView) {
            
            backgroundColor = SKColor.black // Set background colour to black
            
            physicsWorld.gravity = CGVector.zero // No gravity
            physicsWorld.contactDelegate = self // Recognize collisions
           
            // CREATE AND POSITION NIGHTBALL ===========================================================================
            
            // Add center node
            centerNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            centerNode.scale(to: CGSize(width: 50, height: 50))
            self.addChild(centerNode)
            
            // Add quadrants
            
            // Add red quadrant to top right
            quadrantRed.position = CGPoint(x: size.width * 0.35, y: size.height * 0.2)
            quadrantRed.scale(to: CGSize(width: 400, height: 400))
            quadrantRed.zPosition = 1
            centerNode.addChild(quadrantRed)
            
                // Physics for red quadrant
                quadrantRed.physicsBody = SKPhysicsBody(circleOfRadius: quadrantRed.size.width/100)
                quadrantRed.physicsBody?.isDynamic = true
                quadrantRed.physicsBody?.categoryBitMask = PhysicsCategory.quadrantRed
                quadrantRed.physicsBody?.contactTestBitMask = PhysicsCategory.star
                quadrantRed.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            // Add green quadrant to top left
            quadrantGreen.position = CGPoint(x: size.width * -0.35, y: size.height * 0.2)
            quadrantGreen.scale(to: CGSize(width: 400, height: 400))
            quadrantGreen.zPosition = 1
            centerNode.addChild(quadrantGreen)
            
                // Physics for green quadrant
                quadrantGreen.physicsBody = SKPhysicsBody(circleOfRadius: quadrantGreen.size.width/100)
                quadrantGreen.physicsBody?.isDynamic = true
                quadrantGreen.physicsBody?.categoryBitMask = PhysicsCategory.quadrantGreen
                quadrantGreen.physicsBody?.contactTestBitMask = PhysicsCategory.star
                quadrantGreen.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            // Add blue quadrant to bottom right
            quadrantBlue.position = CGPoint(x: size.width * 0.35, y: size.height * -0.2)
            quadrantBlue.scale(to: CGSize(width: 400, height: 400))
            quadrantBlue.zPosition = 1
            centerNode.addChild(quadrantBlue)
            
                // Physics for blue quadrant
                quadrantBlue.physicsBody = SKPhysicsBody(circleOfRadius: quadrantBlue.size.width/100)
                quadrantBlue.physicsBody?.isDynamic = true
                quadrantBlue.physicsBody?.categoryBitMask = PhysicsCategory.quadrantBlue
                quadrantBlue.physicsBody?.contactTestBitMask = PhysicsCategory.star
                quadrantBlue.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            // Add yellow quadrant to bottom left
            quadrantYellow.position = CGPoint(x: size.width * -0.35, y: size.height * -0.2)
            quadrantYellow.scale(to: CGSize(width: 400, height: 400))
            quadrantYellow.zPosition = 1
            centerNode.addChild(quadrantYellow)
            
                // Physics for yellow quadrant
                quadrantYellow.physicsBody = SKPhysicsBody(circleOfRadius: quadrantYellow.size.width/100)
                quadrantYellow.physicsBody?.isDynamic = true
                quadrantYellow.physicsBody?.categoryBitMask = PhysicsCategory.quadrantYellow
                quadrantYellow.physicsBody?.contactTestBitMask = PhysicsCategory.star
                quadrantYellow.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            // Add moon
            moon.position = CGPoint(x: size.width * 0.2, y: size.height * 0.9)
            moon.scale(to: CGSize(width: 75, height: 75))
            addChild(moon)
        
            // Continiously spawn projectiles
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addstar),
                    SKAction.wait(forDuration: 1.0)
                    ])
            ))
    }
        
        // TOUCH INPUT ====================================================================================================
        
        // Sense the location of the touch of the user and rotate nightball in that direction
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch: AnyObject in touches {
                //Find Location
                let location = touch.location(in: self)
                // Rotate Left
                if(location.x < self.frame.size.width/2){
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(Double.pi / 2), duration: 0.25))
                    centerNode.run(rotateAction)
                }
                // Rotate Right
                else if(location.x > self.frame.size.width/2){
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(-Double.pi / 2), duration: 0.25))
                    centerNode.run(rotateAction)
                }
            }
        }
        
        //CREATE STARS ==============================================================================================
        
        // Generate random numbers
        func random() -> CGFloat {
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        func random(min: CGFloat, max: CGFloat) -> CGFloat {
            return random() * (max - min) + min
        }
        
        // Create star
        func addstar() {
            
            // Use yellow star image
            let star = SKSpriteNode(imageNamed: "Star-Yellow")
            
            // Resize projectile
            star.scale(to: CGSize(width:80, height: 80))
            
            // Set animation speed (time)
            let duration = CGFloat(2.0)
            
            // Generate a number to determine which corner the star comes from
            let corner = random(min: 0, max: 4)
        
            if (corner < 1) {
                star.position = CGPoint(x:0, y: size.height) // Top left
            } else if (corner < 2) {
                star.position = CGPoint(x:size.width, y: size.height) // Top right
            } else if (corner < 3) {
                star.position = CGPoint(x:0, y: 0) // Bottom left
            } else {
                star.position = CGPoint(x:size.width, y: 0) // Bottom right
            }
            
            addChild(star) // Add star to scene
            
            //Physics for star
            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width/2)
            star.physicsBody?.isDynamic = true
            star.physicsBody?.categoryBitMask = PhysicsCategory.star
            star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantRed
            star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantGreen
            star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantBlue
            star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantYellow
            star.physicsBody?.collisionBitMask = PhysicsCategory.None
            star.physicsBody?.usesPreciseCollisionDetection = true
            
            
            //Animate star to move toward centre of screen and remove itself when it reaches the centre
            let actionMove = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: TimeInterval(duration))
            let actionMoveDone = SKAction.removeFromParent()
            star.run(SKAction.sequence([actionMove, actionMoveDone]))
            
            
            // ROTATE THE STAR
            
            // Randomize rotation direction
            let direction = random(min: 0, max: 2)
            var rotationAngle = CGFloat()
            if (direction < 1) {
                rotationAngle = CGFloat.pi * 2
            } else {
                rotationAngle = -(CGFloat.pi * 2)
            }
            
            // Rotate the star continuously
            let oneRevolution:SKAction = SKAction.rotate(byAngle: rotationAngle, duration: 3)
            let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
            star.run(repeatRotation)
            
        }
        
        // Remove yellow star when it collides with yellow quadrant
        func starGoodCollision(star: SKSpriteNode, quadrant: SKSpriteNode) {
            print("Hit")
            star.removeFromParent()
        }
        
        // End game when yellow star collides with other quadrants
        func starBadCollision(star: SKSpriteNode, quadrant: SKSpriteNode) {
            print("End")
            
            let loseAction = SKAction.run() {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            star.run(loseAction)
        }
        
        
        func didBegin(_ contact: SKPhysicsContact) {
            
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            // If yellow star contacts yellow quadrant
            if ((firstBody.categoryBitMask & PhysicsCategory.quadrantYellow != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.star != 0)) {
                if let quadrantYellow = firstBody.node as? SKSpriteNode, let
                    star = secondBody.node as? SKSpriteNode {
                    starGoodCollision(star: star, quadrant: quadrantYellow)
                }
            }
            
            // If yellow star contacts other quadrant
            if ((firstBody.categoryBitMask & PhysicsCategory.quadrantBlue != 0) &&
                (secondBody.categoryBitMask & PhysicsCategory.star != 0)) {
                if let quadrantYellow = firstBody.node as? SKSpriteNode, let
                    star = secondBody.node as? SKSpriteNode {
                    starBadCollision(star: star, quadrant: quadrantYellow)
                }
                
            }
            
        }
}
