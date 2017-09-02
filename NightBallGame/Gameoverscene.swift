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

    init(size: CGSize, won:Bool, score: Int) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "You Lose :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // Display Score
        let label2 = SKLabelNode(fontNamed: "Chalkduster")
        label2.text = "Points = " + String(score)
        label2.fontSize = 20
        label2.fontColor = SKColor.black
        label2.position = CGPoint(x: size.width/2, y: size.height/3)
        addChild(label2)
        
        label3.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
        label3.fontSize = 20
        label3.fontColor = SKColor.black
        label3.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(label3)
        
        func saveHighScore(){
            UserDefaults.standard.set(score, forKey: "HIGHSCORE")
            label3.text = "High Score = \(UserDefaults().integer(forKey: "HIGHSCORE"))"
            
            
        }
        
        if score > UserDefaults().integer(forKey: "HIGHSCORE"){
            saveHighScore()
        }
        
       

       

                   /*
        if (score > highscore){
            
            highscore = score
            let label3 = SKLabelNode(fontNamed: "Chalkduster")
            label3.text = "Highscore = " + String(highscore)
            label3.fontSize = 20
            label3.fontColor = SKColor.black
            label3.position = CGPoint(x: size.width/2, y: size.height/4)
            addChild(label3)
            
            var highscoreDefault = UserDefaults.standard
            
            highscoreDefault.setValue(highscore, forKey: "highscore")
            
        }
 */
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


