//
//  MidnightGameScene.swift
//  NightBall
//
//  Created by Danny Lan on 2018-07-16.
//  Copyright © 2018 Keener Studio. All rights reserved.
//


import SpriteKit
import GameplayKit
import AVFoundation
import Foundation


class MidnightGameScene: SKScene,SKPhysicsContactDelegate {
    
    // MARK: Music
    var AudioPlayer1 = AVAudioPlayer()
    var AudioPlayer2 = AVAudioPlayer()
    var AudioPlayer5 = AVAudioPlayer()
    
    // MARK: Nodes
    // Adding the center node which the nightball will rotate around (essentially acts as an anchor point)
    let worldNode = SKNode()
    var dimNode = SKSpriteNode()
    let centerNode: SKSpriteNode = SKSpriteNode(imageNamed: "Nightball - Circle")
    // Adding the quadrants of the nightball
    let quadrantRed = SKSpriteNode(imageNamed: "Quadrant-TR-Red")
    let quadrantGreen = SKSpriteNode(imageNamed: "Quadrant-TL-Green")
    let quadrantBlue = SKSpriteNode(imageNamed: "Quadrant-BR-Blue")
    let quadrantYellow = SKSpriteNode(imageNamed: "Quadrant-BL-Yellow")
    
    var centerNodeScale:CGFloat = 0.14
    let quadrantBlackTR = SKSpriteNode(imageNamed: "Quadrant-BL-Black")
    let quadrantBlackTL = SKSpriteNode(imageNamed: "Quadrant-BL-Black")
    let quadrantBlackBR = SKSpriteNode(imageNamed: "Quadrant-BL-Black")
    let quadrantBlackBL = SKSpriteNode(imageNamed: "Quadrant-BL-Black")
    
    var quadrantHeightScaleConstant:CGFloat = 0.58
    var quadrantWidthScaleConstant:CGFloat = 0.91
    var quadrantHeightPositionConstant:CGFloat = 0.20
    var quadrantWidthPositionConstant:CGFloat = 0.35
    
    let pause = SKSpriteNode(imageNamed: "pause")
    let play = SKSpriteNode(imageNamed: "play")
    var shouldShowLockIcon = false;
    // MARK: - Spawn stars
    
    var starTimer = TimeInterval(1.8)
    var starInterval = TimeInterval(1.8)
    var past = TimeInterval(0)
    var divisionFactor = 1.07
    
    override func update(_ currentTime: TimeInterval) {
        if worldNode.isPaused {
            past = 0
            return
        }
        
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
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "MidnightTrial")
    
    // Score Counter
    var points = 0
    var myLabel = SKLabelNode(fontNamed: "Quicksand-Light")
    
    // access global AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fadeTimer = Timer()
    var fadeStatus = 0

    init(size: CGSize,audio: Bool,shouldLockIconShow: Bool) {
        super.init(size: size)
        shouldShowLockIcon = shouldLockIconShow
        addChild(worldNode)
        dimNode = SKSpriteNode(color: .black, size: CGSize(width: size.width * 2, height: size.height * 2))
        dimNode.alpha = 0
        dimNode.zPosition = 10
        worldNode.addChild(dimNode)
        
        //Update Scaling for iPhoneX
        updateScaling()
        
        // retrieve ismuted bool from global AppDelegate
        let  ismuted = appDelegate.ismuted
        
        // Add Music
        let AssortedMusics5 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bluewhale", ofType: "mp3")!)
        AudioPlayer5 = try! AVAudioPlayer(contentsOf: AssortedMusics5 as URL)
        
        // Set timestamp in audio to start at
        AudioPlayer5.currentTime = TimeInterval(1.5)
        AudioPlayer5.prepareToPlay()
        AudioPlayer5.numberOfLoops = -1
        
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
            AudioPlayer5.play()
            AudioPlayer1.volume = 1
            AudioPlayer2.volume = 1
        }
        
        
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.size = self.frame.size;
        background.zPosition = -6
        worldNode.addChild(background)
        
        physicsWorld.gravity = CGVector.zero // No gravity
        physicsWorld.contactDelegate = self // Recognize collisions
        
        // MARK: Create and position NightBall
        if(UIScreen.main.bounds.height == 568){
            quadrantHeightScaleConstant = 0.69
            quadrantWidthScaleConstant = 1.17
            centerNodeScale = 0.17
            quadrantHeightPositionConstant = 0.24
            quadrantWidthPositionConstant = 0.42
        }
        
        // Add center node
        centerNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        centerNode.scale(to: CGSize(width: size.width * 0.14, height: size.width * 0.14))
        worldNode.addChild(centerNode)
        
        // Add quadrants
        // Add red quadrant to top right
        createQuadrant(centerNode: centerNode, quadrant: quadrantRed, quadrantHeightPosition:quadrantHeightPositionConstant, quadrantWidthPosition: quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant,quadrantWidthScale:quadrantWidthScaleConstant)
        quadrantRed.physicsBody?.categoryBitMask = PhysicsCategory.quadrantRed
        createTransparentQuadrant(centerNode: centerNode, quadrant: quadrantBlackTR, quadrantHeightPosition:quadrantHeightPositionConstant, quadrantWidthPosition: quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant)
        quadrantBlackTR.xScale = -quadrantBlackTR.xScale;
        quadrantBlackTR.yScale = -quadrantBlackTR.yScale;
        
        // Add green quadrant to top left
        createQuadrant(centerNode: centerNode, quadrant: quadrantGreen, quadrantHeightPosition:quadrantHeightPositionConstant, quadrantWidthPosition: -quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant,quadrantWidthScale:quadrantWidthScaleConstant)
        quadrantGreen.physicsBody?.categoryBitMask = PhysicsCategory.quadrantGreen
        createTransparentQuadrant(centerNode: centerNode, quadrant: quadrantBlackTL, quadrantHeightPosition:quadrantHeightPositionConstant, quadrantWidthPosition: -quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant)
        quadrantBlackTL.yScale = -quadrantBlackTL.yScale;
        
        // Add blue quadrant to bottom right
        createQuadrant(centerNode: centerNode, quadrant: quadrantBlue, quadrantHeightPosition: -quadrantHeightPositionConstant, quadrantWidthPosition: quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant,quadrantWidthScale:quadrantWidthScaleConstant)
        quadrantBlue.physicsBody?.categoryBitMask = PhysicsCategory.quadrantBlue
        createTransparentQuadrant(centerNode: centerNode, quadrant: quadrantBlackBR, quadrantHeightPosition: -quadrantHeightPositionConstant, quadrantWidthPosition: quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant)
        quadrantBlackBR.xScale = -quadrantBlackBR.xScale;
        
        // Add yellow quadrant to bottom left
        createQuadrant(centerNode: centerNode, quadrant: quadrantYellow, quadrantHeightPosition: -quadrantHeightPositionConstant, quadrantWidthPosition: -quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant,quadrantWidthScale:quadrantWidthScaleConstant)
        quadrantYellow.physicsBody?.categoryBitMask = PhysicsCategory.quadrantYellow
        createTransparentQuadrant(centerNode: centerNode, quadrant: quadrantBlackBL, quadrantHeightPosition: -quadrantHeightPositionConstant, quadrantWidthPosition: -quadrantWidthPositionConstant, quadrantHeightScale:quadrantHeightScaleConstant)
        
        // Add Score Label
        myLabel.text = "0"
        myLabel.fontSize = 48
        myLabel.fontColor = SKColor.white
        myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        myLabel.zPosition = 1
        worldNode.addChild(myLabel)
        
        // Create fade timer
        fadeTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(fadeQuadrants), userInfo: nil, repeats: true)
        // Add pause button
        pause.position = CGPoint(x: size.width * 0.5, y: size.height * 0.06)
        pause.scale(to: CGSize(width: size.width * 0.1, height: size.width * 0.1))
        worldNode.addChild(pause)
        
        play.position = CGPoint(x: size.width * 0.5, y: size.height * 0.06)
        play.scale(to: CGSize(width: size.width * 0.1, height: size.width * 0.1))
        play.zPosition = 11
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touch Input
    // Sense the location of the touch of the user and rotate nightball in that direction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == pause {
                worldNode.isPaused = true
                dimNode.alpha = 0.5
                AudioPlayer5.pause()
                physicsWorld.speed = 0
                pause.removeFromParent()
                addChild(play)
            } else if node == play {
                worldNode.isPaused = false
                dimNode.alpha = 0
                if let ismuted = appDelegate.ismuted, !ismuted {
                    AudioPlayer5.play()
                }
                physicsWorld.speed = 1
                play.removeFromParent()
                addChild(pause)
            }
                // Rotate left for taps on left
            else if (!worldNode.isPaused && location.x < self.frame.size.width/2) {
                let rotateAction = (SKAction.rotate(byAngle: CGFloat(Double.pi / 2), duration: 0.25))
                centerNode.run(rotateAction)
            }
                // Rotate right for taps on right
            else if (!worldNode.isPaused) {
                let rotateAction = (SKAction.rotate(byAngle: CGFloat(-Double.pi / 2), duration: 0.25))
                centerNode.run(rotateAction)
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
        
        worldNode.addChild(star) // Add star to scene
        
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
        AudioPlayer5.stop()
        
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = MidnightGameOverScene(size: self.size, won: false, score: self.points,shouldLockIconShow:self.shouldShowLockIcon)
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
    
    @objc func fadeQuadrants() {
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 2)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 2)
        
        if fadeStatus > 2 {
            quadrantRed.run(fadeOut)
            quadrantGreen.run(fadeOut)
            quadrantBlue.run(fadeOut)
            quadrantYellow.run(fadeOut)
            
            quadrantBlackTR.run(fadeIn)
            quadrantBlackTL.run(fadeIn)
            quadrantBlackBR.run(fadeIn)
            quadrantBlackBL.run(fadeIn)
            
            fadeStatus = 0
        } else {
            if fadeStatus == 0 {
                quadrantRed.run(fadeIn)
                quadrantGreen.run(fadeIn)
                quadrantBlue.run(fadeIn)
                quadrantYellow.run(fadeIn)
            
                quadrantBlackTR.run(fadeOut)
                quadrantBlackTL.run(fadeOut)
                quadrantBlackBR.run(fadeOut)
                quadrantBlackBL.run(fadeOut)
            }
            
            fadeStatus += 1
        }
    }
    
    func createQuadrant(centerNode: SKSpriteNode, quadrant: SKSpriteNode, quadrantHeightPosition: CGFloat,quadrantWidthPosition:CGFloat,quadrantHeightScale:CGFloat,quadrantWidthScale:CGFloat) {
        
        quadrant.position = CGPoint(x: size.width * quadrantWidthPosition, y: size.height * quadrantHeightPosition)
        quadrant.scale(to: CGSize(width: size.width * quadrantWidthScale, height: size.height * quadrantHeightScale))
        quadrant.zPosition = 1
        centerNode.addChild(quadrant)
        quadrant.physicsBody = SKPhysicsBody(circleOfRadius: quadrant.size.width/100)
        quadrant.physicsBody?.isDynamic = true
        quadrant.physicsBody?.contactTestBitMask = PhysicsCategory.star
        quadrant.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func createTransparentQuadrant(centerNode: SKSpriteNode, quadrant: SKSpriteNode, quadrantHeightPosition: CGFloat,quadrantWidthPosition:CGFloat,quadrantHeightScale:CGFloat) {
        
        quadrant.position = CGPoint(x: size.width * quadrantWidthPosition, y: size.height * quadrantHeightPosition)
        quadrant.scale(to: CGSize(width: size.width * 0.97, height: size.height * quadrantHeightScale))
        quadrant.zPosition = 2
        quadrant.alpha = 0
        centerNode.addChild(quadrant)
    }
    
    func updateScaling() {
        if(UIScreen.main.bounds.height == 812) {
            quadrantHeightScaleConstant = 0.44
            quadrantHeightPositionConstant = 0.155
            quadrantWidthPositionConstant = 0.33
            background = SKSpriteNode(imageNamed: "GameSceneiPhoneX")
        }else if(UIScreen.main.bounds.height == 736){
            quadrantHeightScaleConstant = 0.52
            quadrantWidthScaleConstant = 0.90
            quadrantHeightPositionConstant = 0.18
            quadrantWidthPositionConstant = 0.33
        }
    }
}

