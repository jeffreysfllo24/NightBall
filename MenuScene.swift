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
import GameKit

class MenuScene: SKScene,GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // Access global AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Music
    var AudioPlayer3 = AVAudioPlayer()
    
    // Music for Gamescene
    var AudioPlayer1 = AVAudioPlayer()
    var AudioPlayer2 = AVAudioPlayer()
    var AudioPlayer4 = AVAudioPlayer()
    
    // Play button image
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Playbutton")
    let midnightPlayButtonTex = SKTexture(imageNamed: "MidnightPlayButton")
    var modeButton = SKSpriteNode()
    let modeTex = SKTexture(image: #imageLiteral(resourceName: "Mode"))
    var midnightOn: Bool = false
    
    var soundIcon = SKSpriteNode()
    let soundIconTex = SKTexture(imageNamed: "SoundIcon")
    let SoundmuteTex = SKTexture (imageNamed: "Soundmute")
    
    let leaderboard: SKSpriteNode = SKSpriteNode(imageNamed:"Leaderboard")
    
    let title: SKSpriteNode = SKSpriteNode(imageNamed: "AppTitle-5")
    let fade: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground1")
    let fade2: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground2")
    let fade3: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground3")
    let fade4: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground4")
    let menuBackground: SKSpriteNode = SKSpriteNode(imageNamed: "menubackground")
    
    override func didMove(to view: SKView) {
        var soundIconHeightScale:CGFloat = size.height * 0.06
        var leaderboardIconHeightScale:CGFloat = size.height * 0.07
        if(UIScreen.main.bounds.height == 812){
            soundIconHeightScale = size.height * 0.047
            leaderboardIconHeightScale = size.height * 0.063
        }
        
        // Add Background
        menuBackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        menuBackground.size = self.frame.size;
        menuBackground.zPosition = -6
        self.addChild(menuBackground)
        
        // Insert Title
        insertSKSpriteNode(object: title, positionWidth: size.width * 0.5, positionHeight: size.height * 0.85,scaleWidth:size.width * 0.6,scaleHeight: size.height * 0.13, zPosition: 1)

        // Insert change mode button
        modeButton = SKSpriteNode(texture: modeTex)
        insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
        
        // Insert Play button
        playButton = SKSpriteNode(texture: playButtonTex)
        insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
        
        // Insert Leaderboard button
        insertSKSpriteNode(object: leaderboard, positionWidth: size.width * 0.65, positionHeight: size.height * 0.162,scaleWidth:size.width * 0.13, scaleHeight: leaderboardIconHeightScale, zPosition: 4)
       
        let  ismuted = appDelegate.ismuted
        
        if ismuted! {
            // Add Muted Icon
            soundIcon = SKSpriteNode(texture: SoundmuteTex)
            insertSKSpriteNode(object: soundIcon, positionWidth:size.width * 0.35, positionHeight: size.height * 0.15,scaleWidth: size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
        } else {
            // Add Sound Icon
            soundIcon = SKSpriteNode(texture: soundIconTex)
            insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.35, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var soundIconHeightScale:CGFloat = size.height * 0.06
        if(UIScreen.main.bounds.height == 812){
            soundIconHeightScale = size.height * 0.047
        }
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if view != nil {
                    let fadeOutAction = SKAction.fadeOut(withDuration: 5)
                    playButton.run(fadeOutAction)
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    if midnightOn {
                        let scene:SKScene = MidnightGameScene(size: self.size,audio: !AudioPlayer3.isPlaying)
                        self.view?.presentScene(scene, transition: transition)
                    } else {
                        let scene:SKScene = GameScene(size: self.size,audio: !AudioPlayer3.isPlaying)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
            }
            
            if node == modeButton {
                playButton.removeFromParent()
                if midnightOn {
                    playButton = SKSpriteNode(texture: playButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = false
                } else {
                    playButton = SKSpriteNode(texture: midnightPlayButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = true
                }
            }
            
            if node == soundIcon {
                // retrieve ismuted bool from global AppDelegate
                let ismuted = appDelegate.ismuted
                // Remove Mute Sound Icon
                soundIcon.removeFromParent()
                if ismuted! {
                    // Replace Mute Sound Icon with Sound Icon
                    soundIcon = SKSpriteNode(texture: soundIconTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.35, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = false
                    AudioPlayer3.play()
                } else {
                    //Add Mute Sound Icon
                    soundIcon = SKSpriteNode(texture: SoundmuteTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.35, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = true
                    AudioPlayer3.pause()
                }
            }
            if node == leaderboard {
                showLeader()
            }
        }
    }
    
    func insertSKSpriteNode(object: SKSpriteNode, positionWidth: CGFloat, positionHeight: CGFloat,scaleWidth: CGFloat,scaleHeight: CGFloat, zPosition: CGFloat){
        object.position = CGPoint(x:positionWidth, y: positionHeight)
        object.scale(to: CGSize(width:scaleWidth, height:scaleHeight))
        object.zPosition = zPosition
        self.addChild(object)
    }
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        gKGCViewController.leaderboardIdentifier = "com.score.nightball"
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
}
