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
    var highscore = UserDefaults().integer(forKey: "HIGHSCORE")
    let Menubackground: SKSpriteNode = SKSpriteNode(imageNamed: "Menubackground")
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
        addChild(refresh)
        
        // Display Score
        let label2 = SKLabelNode(fontNamed: "Chalkduster")
        label2.text = "Score = " + String(score)
        label2.fontSize = 20
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(label2)
        
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
        
       

        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    

    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}


