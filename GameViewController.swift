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
import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
class GameViewController: UIViewController {
    public let defaults = UserDefaults.standard

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
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self

        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            let launch = LaunchScreen(size: view.bounds.size)
                scene.scaleMode = .aspectFill
                view.presentScene(launch)
                view.ignoresSiblingOrder = true
                view.showsNodeCount = true
            
            if view.scene == MenuScene(){
                print("caca")
                bannerView.load(GADRequest())
                addBannerViewToView(bannerView)

            }
            }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }

}
     
