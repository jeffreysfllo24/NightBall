//
//  GameScene.swift
//  NightBallGame
//
//  Created by Danny Lan on 2017-08-15.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let TR: UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}
    class GameScene: SKScene,SKPhysicsContactDelegate {
    
        // Adding the center node which the nightball will rotate around (essentially acts as an anchor point)
        let centerNode: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball - Circle")
        // Adding the parts of the nightball
        let TR: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball TR")
        
        
        let TL: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball TL")
      
        
        let BR: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball BR")
       
        
        let BL: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball BL")
        
        let moon: SKSpriteNode = SKSpriteNode(imageNamed: "Moon")
        
        override func didMove(to view: SKView) {
        
        // Set background colour to black
        backgroundColor = SKColor.black
        
           
            
            // Adding the position of the centernode which will act as the parent in the heirchay
            centerNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            centerNode.scale(to: CGSize(width: 50, height: 50))
            self.addChild(centerNode)
            // Placing each nightball part in position and adding it to the "parent" - centernode
            TR.position = CGPoint(x: size.width * 0.35, y: size.height * 0.2)
            TR.scale(to: CGSize(width: 400, height: 400))
            TR.zPosition = 1
            centerNode.addChild(TR)
                
            TL.position = CGPoint(x: size.width * -0.35, y: size.height * 0.2)
            TL.scale(to: CGSize(width: 400, height: 400))
            TL.zPosition = 1
            centerNode.addChild(TL)
            
            BR.position = CGPoint(x: size.width * 0.35, y: size.height * -0.2)
            BR.scale(to: CGSize(width: 400, height: 400))
            BR.zPosition = 1
            centerNode.addChild(BR)
            
            BL.position = CGPoint(x: size.width * -0.35, y: size.height * -0.2)
            BL.scale(to: CGSize(width: 400, height: 400))
            BL.zPosition = 1
            centerNode.addChild(BL)
            
            moon.position = CGPoint(x: size.width * 0.2, y: size.height * 0.9)
            moon.scale(to: CGSize(width: 75, height: 75))
            addChild(moon)
            
          
            physicsWorld.gravity = CGVector.zero
            physicsWorld.contactDelegate = self

            
        
    
      
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addProjectile),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
    }
        
     
        
        // Sense the location of the touch of the user and rotate nightball in that direction
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch: AnyObject in touches {
                //Find Location
                let location = touch.location(in: self)
                //Rotate Left
                if(location.x < self.frame.size.width/2){
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(Double.pi / 2), duration: 0.25))
                    centerNode.run(rotateAction)
                }
                    //Rotate Right
                else if(location.x > self.frame.size.width/2){
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(-Double.pi / 2), duration: 0.25))
                    centerNode.run(rotateAction)
                    
                }
                
            }
            
            
        }
        //CREATE PROJECTILES
        
        
        // Randomizing functions
        func random() -> CGFloat {
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        func random(min: CGFloat, max: CGFloat) -> CGFloat {
            return random() * (max - min) + min
        }
        // Projectile creating function
        func addProjectile() {
            
            // Create sprite
            let projectile = SKSpriteNode(imageNamed: "projectile")
            
            // Resize projectile
            projectile.scale(to: CGSize(width:80, height: 80))
            
            // Set animation speed (time)
            let duration = CGFloat(2.0)
            
            // Generate a number to determine which cannon the projectile is fired from
            let cannon = random(min: 0, max: 4)
            
            // Top left
            if (cannon < 1) {
                projectile.position = CGPoint(x:0, y: size.height)
            }
                // Top right
            else if (cannon < 2) {
                projectile.position = CGPoint(x:size.width, y: size.height)
            }
                // Bottom left
            else if (cannon < 3) {
                projectile.position = CGPoint(x:0, y: 0)
            }
                // Bottom right
            else {
                projectile.position = CGPoint(x:size.width, y: 0)
            }
            
            // Add projectile to scene
            addChild(projectile)
            
            //Animate projectile to move toward centre of screen and remove itself when it reaches the centre
            let actionMove = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: TimeInterval(duration))
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            
            
            // ROTATE THE PROJECTILE
            
            // Randomize rotation direction
            let direction = random(min: 0, max: 2)
            var rotationAngle = CGFloat()
            if (direction < 1) {
                rotationAngle = CGFloat.pi * 2
            }
            else {
                rotationAngle = -(CGFloat.pi * 2)
            }
            
            // Rotate the projectile continuously
            let oneRevolution:SKAction = SKAction.rotate(byAngle: rotationAngle, duration: 3)
            let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
            projectile.run(repeatRotation)
        }
}
