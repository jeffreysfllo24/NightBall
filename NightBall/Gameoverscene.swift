//
//  Gameoverscene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-28.
//  Copyright © 2017 Keener Studio. All rights reserved.
//
import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let label2 = SKLabelNode(fontNamed: "Quicksand-Light")
    let label3 = SKLabelNode(fontNamed: "Quicksand-Light")
    let label4 = SKLabelNode(fontNamed: "Quicksand-Light")
    var highscore = UserDefaults().integer(forKey: "HIGHSCORE")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "menubackground")
    let refresh: SKSpriteNode = SKSpriteNode(imageNamed: "Refresh")
    let home: SKSpriteNode = SKSpriteNode(imageNamed: "home")
    
    init(size:CGSize, won:Bool, score: Int) {
        
        super.init(size: size)
        
        // Background
        Menubackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        Menubackground.size = self.frame.size;
        Menubackground.zPosition = -6
        addChild(Menubackground)
        
        // Refresh Button
        refresh.position = CGPoint(x: frame.midX, y: frame.midY)
        refresh.scale(to: CGSize(width: size.width * 0.48, height: size.height * 0.27))
        refresh.name = "refresh"
        self.addChild(refresh)
        
        // Home Button
        home.position = CGPoint(x: size.width * 0.85, y: size.height * 0.07)
        home.scale(to: CGSize(width: size.width * 0.12, height: size.height * 0.06))
        home.name = "home"
        self.addChild(home)
        
        // Display Score
        label2.text = "Score = " + String(score)
        label2.fontSize = 30
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.255)
        addChild(label2)
        
        //Display High Score
        label3.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        label3.fontSize = 30
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.175)
        addChild(label3)
        
        // Display how to reset game instructions
        label4.text = "Again?"
        label4.fontSize = 48
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: size.width * 0.5, y: size.height * 0.78)
        addChild(label4)

        //Save Highscore
        func saveHighScore(){
            UserDefaults.standard.set(score, forKey: "HIGHSCORE")
            label3.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        }
        if score > UserDefaults().integer(forKey: "HIGHSCORE"){
            saveHighScore()
        }
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset game upon tap on refresh button
        // If the refresh button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == refresh {
                if let view = view {
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size, audio: false)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
        // Return to menu upon tap on home button
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == home {
                if let view = view {
                    let reveal:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: reveal)
                }
            }
        }
    }
}


