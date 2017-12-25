//
//  MenuScene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-30.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import AVFoundation


class MenuScene: SKScene {
    // Music
        var AudioPlayer3 = AVAudioPlayer()
    
    
    // Play button image
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Playbutton")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "menubackground")
    let SoundIcon: SKSpriteNode = SKSpriteNode(imageNamed: "SoundIcon")
    let title: SKSpriteNode = SKSpriteNode(imageNamed: "AppTitle-5")
    let fade :SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground1")
    let fade2 :SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground2")
    let fade3 :SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground3")
    let fade4 :SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground4")
    
    
    override func didMove(to view: SKView) {
        // Add Background
        Menubackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        Menubackground.size = self.frame.size;
        Menubackground.zPosition = -6
        addChild(Menubackground)
        
        // Insert Title
        title.position = CGPoint(x: size.width * 0.5, y: size.height * 0.85)
        title.scale(to: CGSize(width: size.width * 0.6, height: size.height * 0.13))
        title.zPosition = 1
        addChild(title)
 
        // Insert Play button
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.scale(to: CGSize(width: size.width * 0.6, height: size.width * 0.6))
        playButton.zPosition = 4
        self.addChild(playButton)
       
        // Add Sound Icon
        SoundIcon.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        SoundIcon.scale(to: CGSize(width: size.width * 0.15, height: size.height * 0.06))
        SoundIcon.zPosition = 1
        self.addChild(SoundIcon)
        
        /*
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
 */
        
        
        
        // First Star background
        fade.position = CGPoint(x: size.width * 0.5, y: size.height * 0.4)
        fade.scale(to: CGSize(width: 200, height: 600))
        fade.zPosition = 1
        
        
        let waitAction = SKAction.wait(forDuration: 2)
        let animateList = SKAction.sequence([waitAction, SKAction.fadeIn(withDuration: 1.7),SKAction.fadeOut(withDuration: 1.7)])
        
        let repeatFade:SKAction = SKAction.repeatForever(animateList)

        fade.run(repeatFade)
        
        self.addChild(fade)
        
        // Second Star background
        fade2.position = CGPoint(x: size.width * 0.3, y: size.height * 0.4)
        fade2.scale(to: CGSize(width: 200, height: 600))
        fade2.zPosition = 1
        
        
        let animateList2 = SKAction.sequence([SKAction.fadeIn(withDuration: 5.7),SKAction.fadeOut(withDuration: 5.7)])
        
        let repeatFade2:SKAction = SKAction.repeatForever(animateList2)
        
        fade2.run(repeatFade2)
        
        self.addChild(fade2)
        
        // Third Star background
        fade3.position = CGPoint(x: size.width * 0.7, y: size.height * 0.4)
        fade3.scale(to: CGSize(width: 200, height: 600))
        fade3.zPosition = 1
        
        let waitAction2 = SKAction.wait(forDuration: 1)
        let animateList3 = SKAction.sequence([waitAction2,SKAction.fadeIn(withDuration: 2.6),SKAction.fadeOut(withDuration: 2.6)])
        
        let repeatFade3:SKAction = SKAction.repeatForever(animateList3)
        
        fade3.run(repeatFade3)
        
        self.addChild(fade3)
        
        // Add Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Hypnothis", ofType: "mp3")!)
        AudioPlayer3 = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer3.prepareToPlay()
        AudioPlayer3.numberOfLoops = -1
        AudioPlayer3.play()

    }
    
    // variable to determine if muted or not
    var mute: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Add Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Hypnothis", ofType: "mp3")!)
        AudioPlayer3 = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer3.prepareToPlay()
        AudioPlayer3.numberOfLoops = -1
       
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    let fadeOutAction = SKAction.fadeOut(withDuration: 5)
                    playButton.run(fadeOutAction)
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
            
            if node == SoundIcon {
                if mute == false {
                     mute = true
                    AudioPlayer3.pause()
                } else {
                     mute = false
                    AudioPlayer3.play()
                }
            }
 
        }
        
       
}
}
