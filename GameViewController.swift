//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//
// BOTTOM ADD : ca-app-pub-4889346564502252/3842146359
// INTERSTITIAL : ca-app-pub-4889346564502252/4587133227
// ID ca-app-pub-4889346564502252~7541718210
import UIKit
import SpriteKit
import GameplayKit
//import GoogleMobileAds
class GameViewController: UIViewController {
    public let defaults = UserDefaults.standard


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            let launch = LaunchScreen(size: view.bounds.size)
            //addBannerViewToView(bannerView)
            //bannerView.rootViewController = self
            //bannerView.adUnitID = "ca-app-pub-4889346564502252/3842146359"
            //bannerView.load(GADRequest())
            
                scene.scaleMode = .aspectFill
                view.presentScene(launch)
                //view.showsFPS = true
                view.ignoresSiblingOrder = true
                view.showsNodeCount = true
            	
            }
        }
    

}
     
