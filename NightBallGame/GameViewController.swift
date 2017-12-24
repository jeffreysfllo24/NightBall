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
import AVFoundation

class GameViewController: UIViewController {
    // Music
    // var AudioPlayer = AVAudioPlayer()
    
    // Initial setup of game scene
    override func viewDidLoad() {
        
        /*
        // Add Music
        super.viewDidLoad()
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Hypnothis", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
        */
 
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
    // Music
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Makes sure status bar is not visible
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
