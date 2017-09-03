//
//  MenuScene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-30.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    // PLay button image
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Playbutton")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "Menubackground")
    let SoundIcon: SKSpriteNode = SKSpriteNode(imageNamed: "SoundIcon")
    let title: SKSpriteNode = SKSpriteNode(imageNamed: "AppTitle-1")

    override func didMove(to view: SKView) {
        // Add Background
        Menubackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        Menubackground.size = self.frame.size;
        Menubackground.zPosition = -6
        addChild(Menubackground)
        
        // Insert Title
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.85)
        title.scale(to: CGSize(width: 250, height: 100))
        title.zPosition = 1
        addChild(title)
        
 
        // Insert Play button
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.scale(to: CGSize(width: 200, height: 200))
        playButton.zPosition = 4
        self.addChild(playButton)
       
        // Add Sound Icon
        SoundIcon.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        SoundIcon.scale(to: CGSize(width: 45, height: 45))
        SoundIcon.zPosition = 1
        addChild(SoundIcon)
        
        // Star Animation In progress
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.emitterPosition = CGPoint(x: 200, y: 200)
        
        let cell = CAEmitterCell()
        cell.birthRate = 5
        cell.lifetime = 50
        cell.velocity = 50
        cell.scale = 0.1
        
        
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = UIImage(named: "MenuStar")!.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        view.layer.addSublayer(emitterLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
