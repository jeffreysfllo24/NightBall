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
import SwiftyStoreKit
import StoreKit

var sharedSecret = "f7bf998ad4774783b94f943942a8ee46"

class NetworkActivityIndicatorManage: NSObject{
    private static var loadingCount = 0
    
    class func NetworkOperationStarted(){
        if(loadingCount == 0){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished(){
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
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
    let mode2Tex = SKTexture(image: #imageLiteral(resourceName: "Mode2"))
    let lockIcon:SKSpriteNode = SKSpriteNode(imageNamed: "LockIcon")
    let shoppingCartIcon:SKSpriteNode = SKSpriteNode(imageNamed: "ShoppingCart")
    var midnightOn: Bool = false
    
    var soundIcon = SKSpriteNode()
    let soundIconTex = SKTexture(imageNamed: "SoundIcon")
    let SoundmuteTex = SKTexture (imageNamed: "Soundmute")
    
    let bundleID = "com.keener.nightball.midnightPurchase"
    
    let leaderboard: SKSpriteNode = SKSpriteNode(imageNamed:"Leaderboard")
    let title: SKSpriteNode = SKSpriteNode(imageNamed: "AppTitleWhite")
    let fade1: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground1")
    let fade2: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground2")
    let fade3: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground3")
    let fade4: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground4")
    let menuBackground: SKSpriteNode = SKSpriteNode(imageNamed: "MenuBackgroundNew")
    
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
        
        //Insert Lock Icon
        insertSKSpriteNode(object: lockIcon, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.09, scaleHeight: size.width * 0.09, zPosition: 5)
        lockIcon.alpha = 0.8
        isMidnightModeEnabled()
        
        //Inset Shopping Cart Icon
        insertSKSpriteNode(object: shoppingCartIcon, positionWidth: size.width * 0.75, positionHeight: size.height * 0.162, scaleWidth: size.width * 0.13, scaleHeight: size.height * 0.07, zPosition: 4)
        
        // Insert Play button
        playButton = SKSpriteNode(texture: playButtonTex)
        insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
        
        // Insert Leaderboard button
        insertSKSpriteNode(object: leaderboard, positionWidth: size.width * 0.50, positionHeight: size.height * 0.162,scaleWidth:size.width * 0.13, scaleHeight: leaderboardIconHeightScale, zPosition: 4)
       
        let  ismuted = appDelegate.ismuted
        
        if ismuted! {
            // Add Muted Icon
            soundIcon = SKSpriteNode(texture: SoundmuteTex)
            insertSKSpriteNode(object: soundIcon, positionWidth:size.width * 0.25, positionHeight: size.height * 0.15,scaleWidth: size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
        } else {
            // Add Sound Icon
            soundIcon = SKSpriteNode(texture: soundIconTex)
            insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.25, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
        }

        // Star backgrounds
        animateFade(fade: fade1, delay: 2, duration: 1.7, startingAlpha: 1)
        animateFade(fade: fade2, delay: 0, duration: 5.7, startingAlpha: 0.3)
        animateFade(fade: fade3, delay: 1, duration: 2.6, startingAlpha: 0.7)
        animateFade(fade: fade4, delay: 0, duration: 3.2, startingAlpha: 0.1)
        
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
            
            if (node == modeButton && lockIcon.isHidden){
                modeButton.removeFromParent()
                playButton.removeFromParent()
                if midnightOn {
                    modeButton = SKSpriteNode(texture: modeTex)
                    insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
                    playButton = SKSpriteNode(texture: playButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = false
                } else {
                    modeButton = SKSpriteNode(texture: mode2Tex)
                    insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
                    playButton = SKSpriteNode(texture: midnightPlayButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = true
                }
            }
            
            if(node == lockIcon){
                fadeInGameModeLockedLabel()
            }
            
            if node == soundIcon {
                // retrieve ismuted bool from global AppDelegate
                let ismuted = appDelegate.ismuted
                // Remove Mute Sound Icon
                soundIcon.removeFromParent()
                if ismuted! {
                    // Replace Mute Sound Icon with Sound Icon
                    soundIcon = SKSpriteNode(texture: soundIconTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.25, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = false
                    AudioPlayer3.play()
                } else {
                    //Add Mute Sound Icon
                    soundIcon = SKSpriteNode(texture: SoundmuteTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.25, positionHeight:size.height * 0.15,scaleWidth:size.width * 0.15,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = true
                    AudioPlayer3.pause()
                }
            }
            if node == leaderboard {
                showLeader()
            }
        }
    }
    
    func insertSKSpriteNode(object: SKSpriteNode, positionWidth: CGFloat, positionHeight: CGFloat,scaleWidth: CGFloat,scaleHeight: CGFloat, zPosition: CGFloat) {
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
    
    func isMidnightModeEnabled() {
        if((UserDefaults().integer(forKey: "HIGHSCORE") >= 100)){
            lockIcon.isHidden = true
        }
        else{
            modeButton.color = UIColor.gray
            modeButton.colorBlendFactor = 1
            lockIcon.isHidden = false
        }
    }
    func fadeInGameModeLockedLabel() {
        let gameModeLocked: SKSpriteNode = SKSpriteNode(imageNamed: "newModeLabel")
        gameModeLocked.position = CGPoint(x:size.width * 0.5, y: size.height * 0.73)
        gameModeLocked.scale(to: CGSize(width:size.width * 1.3, height: size.height * 0.30))
        gameModeLocked.zPosition = 6
        let animateLabel = SKAction.sequence([SKAction.fadeIn(withDuration: 1.0),SKAction.wait(forDuration: 2.0),SKAction.fadeOut(withDuration: 1.0)])
        gameModeLocked.run(animateLabel)
        self.addChild(gameModeLocked)
    }
    
    //MARK: In App Purchase Logic
    func getInfo(purchase : String ){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID], completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
        })
    }
    func purchase(purchase : String){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID, completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
        })
    }
    func restorePurchases(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion:{_ in
            NetworkActivityIndicatorManage.networkOperationFinished()
            
        })
    }
    func verifyReceipt(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSecret as! ReceiptValidator, completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
        })
    }
    func verifyPurchase(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: sharedSecret as! ReceiptValidator, completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
        })
    }

}

extension SKScene {
    func animateFade(fade: SKSpriteNode, delay: Double, duration: Double, startingAlpha: CGFloat) {
        fade.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        fade.scale(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        fade.zPosition = -5
        fade.alpha = startingAlpha
        let waitAction = SKAction.wait(forDuration: delay)
        let animateList = SKAction.sequence([waitAction, SKAction.fadeIn(withDuration: duration), SKAction.fadeOut(withDuration: duration)])
        let repeatFade: SKAction = SKAction.repeatForever(animateList)
        fade.run(repeatFade)
        addChild(fade)
    }
    func alertWithTitle(title:String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    func showAlert(alert : UIAlertController){
        guard let _ = self.scene else{
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
    }
    func ForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first{
            let priceString = product.localizedPrice
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(String(describing: priceString))")
        }
        else{
            let errorString = result.error?.localizedDescription ?? "Unknown Error."
            return alertWithTitle(title: "Could not retrieve product info", message: errorString)
        }
    }
}
