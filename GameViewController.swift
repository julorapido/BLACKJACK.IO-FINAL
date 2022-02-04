//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//
// BOTTOM ADD : ca-app-pub-4889346564502252/3842146359
// INTERSTITIAL : ca-app-pub-4889346564502252/4587133227
// ID app : ca-app-pub-4889346564502252~7541718210
//  google if bottom ad : ca-app-pub-3940256099942544/2934735716
//  google rewarded add: ca-app-pub-3940256099942544/1712485313
import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController, GADFullScreenContentDelegate {
    public let defaults = UserDefaults.standard
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        return banner
    }()
    
    
    override func viewDidLoad() {
        banner.rootViewController  = self
        
        super.viewDidLoad()
        let bannerView = GADBannerView(adSize: GADAdSize())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self

        
        if let view = self.view as! SKView? {
            let menuu = MenuScene(size: view.bounds.size)
            let launch = LaunchScreen(size: view.bounds.size)
    
                menuu.scaleMode = .aspectFill
                view.presentScene(launch)
                view.ignoresSiblingOrder = true
                view.showsNodeCount = true
      
            let anal = view.scene

                if anal == launch.scene {
                    view.addSubview(banner)
                    bannerView.load(GADRequest())
                }
                
                if anal == menuu.scene {
                    print("bro")
                }
            
          
            
            }
        }
    
    @IBAction func playVideoAd(_ sender: Any) {

        

        if GADRewardBasedVideoAd.sharedInstance().isReady == true {

            

            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)

            

        }

        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35).integral

    }

}
     
