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
import GameKit
import AVFoundation
import MediaPlayer

class GameViewController: UIViewController {
    
    // Music
    // var AudioPlayer = AVAudioPlayer()
    
    // Initial setup of game scene
    override func viewDidLoad() {
        
        // Call the GC authentication controller
        authenticateLocalPlayer()
        
        let rect = CGRect(x: 50, y: 50 , width: 1000, height: 1000)
        let myView = UIView(frame: rect)
        
        myView.backgroundColor = UIColor.white
        let myVolumeView = MPVolumeView(frame:myView.bounds)
        myView.addSubview(myVolumeView)

        /*
        var highscoreDefault = UserDefaults.standard
        
        if (highscoreDefault.valueforKey("highscore")) == nil {
            highscore = highscoreDefault.valueforKey("highscore") as NSInteger!
            }
        */
        
        let scene = MenuScene(size: view.bounds.size,shouldLockIconShow: true,shouldVerifyPurchase: true)
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.scaleMode = UIScreen.main.bounds.height == 812 ? .resizeFill : .aspectFill
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
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
            }
        }
    }
}
