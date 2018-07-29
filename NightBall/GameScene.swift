//
//  GameScene.swift
//  NightBallGame
//
//  Created by Danny Lan on 2017-08-15.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import Foundation

// MARK: Physics Constraint Struct
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let quadrantRed: UInt32 = 0b1
    static let quadrantGreen: UInt32 = 0b10
    static let quadrantBlue: UInt32 = 0b100
    static let quadrantYellow: UInt32 = 0b1000
    static let star: UInt32 = 0b1001
}

    class GameScene: SKScene,SKPhysicsContactDelegate {
        
        // MARK: Music
        var AudioPlayer1 = AVAudioPlayer()
        var AudioPlayer2 = AVAudioPlayer()
        var AudioPlayer4 = AVAudioPlayer()
        
        // MARK: Nodes
        // Adding the center node which the nightball will rotate around (essentially acts as an anchor point)
        let centerNode: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball - Circle")
        // Adding the quadrants of the nightball
        let quadrantRed = SKSpriteNode(imageNamed: "Quadrant-TR-Red")
        let quadrantGreen = SKSpriteNode(imageNamed: "Quadrant-TL-Green")
        let quadrantBlue = SKSpriteNode(imageNamed: "Quadrant-BR-Blue")
        let quadrantYellow = SKSpriteNode(imageNamed: "Quadrant-BL-Yellow")
        var quadrantHeightScaleConstant:CGFloat = 0.54
        var quadrantHeightPositionConstant:CGFloat = 0.2
        var quadrantWidthPositionConstant:CGFloat = 0.35
        
        let tutorialRight = SKSpriteNode(imageNamed: "TutorialRight")
        let tutorialLeft = SKSpriteNode(imageNamed: "TutorialLeft")
        var tutorial = false
        
        // MARK: - Spawn stars
        
        var starTimer = TimeInterval(1.8)
        var starInterval = TimeInterval(1.8)
        var past = TimeInterval(0)
        var divisionFactor = 1.07
        
        override func update(_ currentTime: TimeInterval) {
            if tutorial { return }
            
            if (past == 0) {
                past = currentTime // Take first timestamp
            } else {
                starTimer -= currentTime - past // Subtract time elapsed from timer
                past = currentTime // Take past time so it can be subtracted from the current time
            }
            if starTimer <= 0 { // When timer reaches zero
                addStar(duration: (starInterval + 1)) // Spawn a star
                starTimer = starInterval // Reset the timer
                print(starInterval)
                
                if starInterval < 0.7 {
                    divisionFactor = 1.0005
                } else if starInterval < 0.8 {
                    divisionFactor = 1.002
                } else if starInterval < 1 {
                    divisionFactor = 1.01
                }
                
                starInterval /= divisionFactor
            }
        }

        // Background
        var background: SKSpriteNode = SKSpriteNode(imageNamed: "StarTrial")
        
        // Score Counter
        var points = 0
        var myLabel = SKLabelNode(fontNamed: "Quicksand-Light")
        
        // access global AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        init(size: CGSize,audio: Bool) {
            super.init(size: size)
            
            //Update Scaling for iPhoneX
            updateScaling()
            
            // retrieve ismuted bool from global AppDelegate
            let  ismuted = appDelegate.ismuted
            
            // Add Music
            let AssortedMusics4 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bluewhale", ofType: "mp3")!)
            AudioPlayer4 = try! AVAudioPlayer(contentsOf: AssortedMusics4 as URL)
            
            // Set timestamp in audio to start at
            AudioPlayer4.currentTime = TimeInterval(1.5)
            AudioPlayer4.prepareToPlay()
            AudioPlayer4.numberOfLoops = -1

            let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Beep13", ofType: "wav")!)
            AudioPlayer1 = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
            AudioPlayer1.prepareToPlay()
            AudioPlayer1.numberOfLoops = 1
            
            let AssortedMusics2 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Explosion10", ofType: "wav")!)
            AudioPlayer2 = try! AVAudioPlayer(contentsOf: AssortedMusics2 as URL)
            AudioPlayer2.prepareToPlay()
            AudioPlayer2.numberOfLoops = 1
            
            if ismuted! {
                // turn off music
                AudioPlayer1.volume = 0
                AudioPlayer2.volume = 0
            }
            else{
                //turn on music
                AudioPlayer4.play()
                AudioPlayer1.volume = 1
                AudioPlayer2.volume = 1
            }
        
            background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            background.size = self.frame.size;
            background.zPosition = -6
            addChild(background)
            
            if UserDefaults().integer(forKey: "HIGHSCORE") == 0 {
                tutorial = true
                
                tutorialRight.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                tutorialRight.size = self.frame.size;
                tutorialRight.zPosition = -5
                tutorialRight.alpha = 0
                addChild(tutorialRight)
                tutorialRight.run(SKAction.fadeIn(withDuration: 0.5))
                
                tutorialLeft.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                tutorialLeft.size = self.frame.size;
                tutorialLeft.zPosition = -5
                tutorialLeft.alpha = 0
            }
            
            physicsWorld.gravity = CGVector.zero // No gravity
            physicsWorld.contactDelegate = self // Recognize collisions
           
            // MARK: Create and position NightBall
            
            // Add center node
            centerNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            centerNode.scale(to: CGSize(width: size.width * 0.14, height: size.width * 0.14))
            self.addChild(centerNode)
            
            // Add quadrants
            
            // Add red quadrant to top right
           createQuadrant(centerNode: centerNode, quadrant: quadrantRed,quadrantHeightPoisition:quadrantHeightPositionConstant,quadrantWidthPoisition:quadrantWidthPositionConstant,quadrantHeightScale:quadrantHeightScaleConstant)
            quadrantRed.physicsBody?.categoryBitMask = PhysicsCategory.quadrantRed
            
            // Add green quadrant to top left
            createQuadrant(centerNode: centerNode, quadrant: quadrantGreen,quadrantHeightPoisition:quadrantHeightPositionConstant,quadrantWidthPoisition:-quadrantWidthPositionConstant,quadrantHeightScale:quadrantHeightScaleConstant)
            quadrantGreen.physicsBody?.categoryBitMask = PhysicsCategory.quadrantGreen
            
            
            // Add blue quadrant to bottom right
            createQuadrant(centerNode: centerNode, quadrant: quadrantBlue,quadrantHeightPoisition:-quadrantHeightPositionConstant,quadrantWidthPoisition:quadrantWidthPositionConstant,quadrantHeightScale:quadrantHeightScaleConstant)
            quadrantBlue.physicsBody?.categoryBitMask = PhysicsCategory.quadrantBlue
            
            // Add yellow quadrant to bottom left
            createQuadrant(centerNode: centerNode, quadrant: quadrantYellow,quadrantHeightPoisition:-quadrantHeightPositionConstant,quadrantWidthPoisition:-quadrantWidthPositionConstant,quadrantHeightScale:quadrantHeightScaleConstant)
            quadrantYellow.physicsBody?.categoryBitMask = PhysicsCategory.quadrantYellow
            
            // Add Score Label
            myLabel.text = "0"
            myLabel.fontSize = 48
            myLabel.fontColor = SKColor.white
            myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
            myLabel.zPosition = 1
            addChild(myLabel)
            
            
            
    }
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touch Input
    // Sense the location of the touch of the user and rotate nightball in that direction
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
                        
            // Rotate left for taps on left
            if(location.x < self.frame.size.width/2){
                let rotateAction = (SKAction.rotate(byAngle: CGFloat(Double.pi / 2), duration: 0.25))
                centerNode.run(rotateAction)
                if tutorial {
                    tutorialLeft.run(SKAction.fadeOut(withDuration: 0.5)) { () in
                        self.tutorialLeft.removeFromParent()
                    }
                    tutorial = false
                }
            }
            // Rotate right for taps on right
            else {
                let rotateAction = (SKAction.rotate(byAngle: CGFloat(-Double.pi / 2), duration: 0.25))
                centerNode.run(rotateAction)
                if tutorial {
                    tutorialRight.run(SKAction.fadeOut(withDuration: 0.5)) { () in
                        self.tutorialRight.removeFromParent()
                        self.addChild(self.tutorialLeft)
                        self.tutorialLeft.run(SKAction.fadeIn(withDuration: 0.5))
                    }
                }
            }
        }
    }
        
    // MARK: Create Stars
        
    // Generate random numbers
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
        
    // Create star
    func addStar(duration: TimeInterval) {
            
        // Generate a number to determine which colour of star is created
        let colour = random(min: 0, max: 4)
            
        // Give correct image to sprite and give it an identifier
        var star = SKSpriteNode(imageNamed: "STar-red")
        star.userData = ["color": "red"]
        if (colour < 1) {
            star = SKSpriteNode(imageNamed: "Star-green")
            star.userData = ["color": "green"]
        } else if (colour < 2) {
            star = SKSpriteNode(imageNamed: "Star-blue")
            star.userData = ["color": "blue"]
        } else if (colour < 3) {
            star = SKSpriteNode(imageNamed: "Star-Yellow")
            star.userData = ["color": "yellow"]
        }
            
        // Resize projectile
        star.scale(to: CGSize(width: size.width * 0.22, height: size.width * 0.22))
            
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
            
        // Physics for star
        star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width/2)
        star.physicsBody?.isDynamic = true
        star.physicsBody?.categoryBitMask = PhysicsCategory.star
        star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantRed
        star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantGreen
        star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantBlue
        star.physicsBody?.contactTestBitMask = PhysicsCategory.quadrantYellow
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.usesPreciseCollisionDetection = true
            
        // Animate star to move toward centre of screen and remove itself when it reaches the centre
        let actionMove = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: duration)
        let actionMoveDone = SKAction.removeFromParent()
        star.run(SKAction.sequence([actionMove, actionMoveDone]))
            
        // MARK: Rotate the Star
            
        // Randomize rotation direction
        let direction = random(min: 0, max: 2)
        var rotationAngle = CGFloat()
        if (direction < 1) {
            rotationAngle = CGFloat.pi * 2
        } else {
            rotationAngle = -(CGFloat.pi * 2)
        }
            
        // Rotate the star continuously
        let oneRevolution:SKAction = SKAction.rotate(byAngle: rotationAngle, duration: duration)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        star.run(repeatRotation)
    }
        
    // Remove star when it collides with right quadrant
    func starGoodCollision(star: SKSpriteNode) {
        print("Hit")
        star.removeFromParent()
        AudioPlayer1.play()
        
        // Increase Score when succesful collision
        points += 1
        myLabel.text = String(points)
    }
        
    // End game when star collides with wrong quadrant
    func starBadCollision() {
        print("End")
        AudioPlayer2.play()
        
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.points)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        self.run(loseAction)
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
            
        let star = secondBody.node as? SKSpriteNode
            
        // MARK: Collision detection
            
        if let userData = star?.userData, let color = userData["color"] as? String {
            if (secondBody.categoryBitMask & PhysicsCategory.star != 0) && (color == "red"),
                (firstBody.categoryBitMask & PhysicsCategory.quadrantRed != 0),
                let star = secondBody.node as? SKSpriteNode {
                    
                starGoodCollision(star: star)
                return
                    
            } else if (secondBody.categoryBitMask & PhysicsCategory.star != 0) && (color == "green"),
                (firstBody.categoryBitMask & PhysicsCategory.quadrantGreen != 0),
                let star = secondBody.node as? SKSpriteNode {
                
                starGoodCollision(star: star)
                return
                    
            } else if (secondBody.categoryBitMask & PhysicsCategory.star != 0) && (color == "blue"),
                (firstBody.categoryBitMask & PhysicsCategory.quadrantBlue != 0),
                let star = secondBody.node as? SKSpriteNode {
                    
                starGoodCollision(star: star)
                return
                    
            } else if (secondBody.categoryBitMask & PhysicsCategory.star != 0) && (color == "yellow"),
                (firstBody.categoryBitMask & PhysicsCategory.quadrantYellow != 0),
                let star = secondBody.node as? SKSpriteNode {
                    
                starGoodCollision(star: star)
                return
            }
        }
        starBadCollision()
            
    }
        
    func createQuadrant(centerNode: SKSpriteNode, quadrant: SKSpriteNode,quadrantHeightPoisition:CGFloat,quadrantWidthPoisition:CGFloat,quadrantHeightScale:CGFloat) {
        quadrant.position = CGPoint(x: size.width * quadrantWidthPoisition, y: size.height * quadrantHeightPoisition)
        quadrant.scale(to: CGSize(width: size.width * 0.97, height: size.height * quadrantHeightScale))
        quadrant.zPosition = 1
        centerNode.addChild(quadrant)
        quadrant.physicsBody = SKPhysicsBody(circleOfRadius: quadrant.size.width/100)
        quadrant.physicsBody?.isDynamic = true
        quadrant.physicsBody?.contactTestBitMask = PhysicsCategory.star
        quadrant.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
        
    func updateScaling() {
        if UIScreen.main.bounds.height == 812 {
            quadrantHeightScaleConstant = 0.47
            quadrantHeightPositionConstant = 0.16
            background = SKSpriteNode(imageNamed: "GameSceneiPhoneX")
        }
    }
}
