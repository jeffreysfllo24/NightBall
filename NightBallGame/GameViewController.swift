//
//  GameViewController.swift
//  NightBallGame
//
//  Created by Danny Lan on 2017-08-15.
//  Copyright © 2017 Keener Studio. All rights reserved.
//



import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // Initial setup of game scene
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var highscoreDefault = UserDefaults.standard
        
        if (highscoreDefault.valueforKey("highscore")) == nil {
            highscore = highscoreDefault.valueforKey("highscore") as NSInteger!
            }
        */
        
        let scene = MenuScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    // Makes sure status bar is not visible
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
