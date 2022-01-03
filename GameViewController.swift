//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController {
    


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        bannerView.adUnitID = "ca-app-pub-4889346564502252/3842146359"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
                view.addSubview(bannerView)
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                view.showsFPS = true
                view.ignoresSiblingOrder = true
                //view.showsNodeCount = true
            	
            }
        }
}
     
 
extension UIViewController : GADBannerViewDelegate  {
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("RECEIVE ADD")
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("EROROROEOROREOEREROEROREOEROEROREO")
    }
}
