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
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(Double.pi / 2), duration: 1))
                    centerNode.run(rotateAction)
                }
                    //Rotate Right
                else if(location.x > self.frame.size.width/2){
                    let rotateAction = (SKAction.rotate(byAngle: CGFloat(-Double.pi / 2), duration: 1))
                    centerNode.run(rotateAction)
                    
                }
                
            }
            
            
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
