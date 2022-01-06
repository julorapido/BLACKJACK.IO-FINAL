//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//
// BOTTOM ADD : ca-app-pub-4889346564502252/3842146359
// INTERSTITIAL : ca-app-pub-4889346564502252/4587133227
import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController {
    

    var bannerView: GADBannerView!

    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            //addBannerViewToView(bannerView)
            //bannerView.rootViewController = self
            //bannerView.adUnitID = "ca-app-pub-4889346564502252/3842146359"
            //bannerView.load(GADRequest())
            
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                view.showsFPS = true
                view.ignoresSiblingOrder = true
                view.showsNodeCount = true
            	
            }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerView.frame = CGRect(x: 0, y: view.frame.size.height-50, width: view.frame.size.width, height: 50).integral

    }
}
     
