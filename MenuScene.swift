//
//  MenuScene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-30.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit 

class MenuScene: SKScene {
    // Music
    var AudioPlayer3 = AVAudioPlayer()
    
    // Music for Gamescene
    var AudioPlayer1 = AVAudioPlayer()
    var AudioPlayer2 = AVAudioPlayer()
    var AudioPlayer4 = AVAudioPlayer()
    
    // Play button image
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Playbutton")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "menubackground")
    var SoundIcon = SKSpriteNode()
    let SoundIconTex = SKTexture(imageNamed: "SoundIcon")
    var Soundmute = SKSpriteNode()
    let SoundmuteTex = SKTexture (imageNamed: "Soundmute")
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
       
        let  ismuted = appDelegate.ismuted
        
        if ismuted! {
            // Add Muted Icon
            Soundmute = SKSpriteNode(texture: SoundmuteTex)
            Soundmute.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
            Soundmute.scale(to: CGSize(width: size.width * 0.15, height: size.height * 0.06))
            Soundmute.zPosition = 4
            self.addChild(Soundmute)
        } else {
            // Add Sound Icon
            SoundIcon = SKSpriteNode(texture: SoundIconTex)
            SoundIcon.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
            SoundIcon.scale(to: CGSize(width: size.width * 0.15, height: size.height * 0.06))
            SoundIcon.zPosition = 4
            self.addChild(SoundIcon)
        }
        
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
        
        if !ismuted! {
                    AudioPlayer3.play()
        }
    }
    
    // access global AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if let view = view {
                    if AudioPlayer3.isPlaying{
                        let fadeOutAction = SKAction.fadeOut(withDuration: 5)
                        playButton.run(fadeOutAction)
                        let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                        let scene:SKScene = GameScene(size: self.size,audio: false)
                        self.view?.presentScene(scene, transition: transition)
                    }
                    else{
                        let fadeOutAction = SKAction.fadeOut(withDuration: 5)
                        playButton.run(fadeOutAction)
                        let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                        let scene:SKScene = GameScene(size: self.size,audio: true)
                        self.view?.presentScene(scene, transition: transition)
                    }
                    
                }
            }
            
            if node == SoundIcon || node == Soundmute {
                
                // retrieve ismuted bool from global AppDelegate
                let  ismuted = appDelegate.ismuted
                
                if ismuted! {
                    // Remove Mute Sound Icon
                    Soundmute.removeFromParent()
                    
                    // Replace Mute Sound Icon with Sound Icon
                    SoundIcon = SKSpriteNode(texture: SoundIconTex)
                    SoundIcon.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
                    SoundIcon.scale(to: CGSize(width: size.width * 0.15, height: size.height * 0.06))
                    SoundIcon.zPosition = 4
                    self.addChild(SoundIcon)
                    
                    appDelegate.ismuted = false
                    AudioPlayer3.play()
                } else {
                    //Remove SoundIcon
                    SoundIcon.removeFromParent()
                    
                    //Add Mute Sound Icon
                    Soundmute = SKSpriteNode(texture: SoundmuteTex)
                    Soundmute.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
                    Soundmute.scale(to: CGSize(width: size.width * 0.15, height: size.height * 0.06))
                    Soundmute.zPosition = 4
                    self.addChild(Soundmute)
                    
                    appDelegate.ismuted = true
                    AudioPlayer3.pause()
                }
            }
 
        }
        
       
}
}
