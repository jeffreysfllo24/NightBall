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
    let label3 = SKLabelNode(fontNamed: "Chalkduster")
    let label4 = SKLabelNode(fontNamed: "Chalkduster")
    var highscore = UserDefaults().integer(forKey: "HIGHSCORE")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "StarTrial")
    let refresh: SKSpriteNode = SKSpriteNode(imageNamed: "Refresh")
    
    init(size: CGSize, won:Bool, score: Int) {
        
        super.init(size: size)
        
        // Background
        Menubackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        Menubackground.size = self.frame.size;
        Menubackground.zPosition = -6
        addChild(Menubackground)
        
        // Refresh Button
        refresh.position = CGPoint(x: frame.midX, y: frame.midY)
        refresh.scale(to: CGSize(width: 200, height: 200))
        refresh.name = "refresh"
        self.addChild(refresh)
        
        // Display Score
        let label2 = SKLabelNode(fontNamed: "Chalkduster")
        label2.text = "Score = " + String(score)
        label2.fontSize = 20
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(label2)
        
        // Display how to reset game instructions
        label4.text = "Tap Button To Restart"
        label4.fontSize = 20
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: size.width/2, y: size.height/1.2)
        addChild(label4)
        
        //Display High Score
        label3.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        label3.fontSize = 20
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: size.width/2, y: size.height/6)
        addChild(label3)
        
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
    // Reset game upon tap on refresh button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == refresh {
                if let view = view {
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}


