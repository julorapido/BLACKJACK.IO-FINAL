//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
        let color1: CGColor = UIColor(red: 209/255, green: 107/255, blue: 165/255, alpha: 1).cgColor
        let color2: CGColor = UIColor(red: 134/255, green: 168/255, blue: 231/255, alpha: 1).cgColor
        let color3: CGColor = UIColor(red: 95/255, green: 251/255, blue: 241/255, alpha: 1).cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        var gradientColorSet: [[CGColor]] = []
        var colorIndex: Int = 0
    
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            if flag {
                animateGradient()
            }
        }
        
        func setupGradient(){
            gradientColorSet = [
                [color1, color2],
                [color2, color3],
                [color3, color1]
            ]
            gradient.frame = self.view.bounds
            gradient.colors = gradientColorSet[colorIndex]
            self.view.layer.addSublayer(gradient)
        }
        
    
    
    
    
        func animateGradient() {
            gradient.colors = gradientColorSet[colorIndex]
            
            let gradientAnimation = CABasicAnimation(keyPath: "colors")
            gradientAnimation.duration = 3.0
            
            updateColorIndex()
            gradientAnimation.toValue = gradientColorSet[colorIndex]
            
            gradientAnimation.fillMode = .forwards
            gradientAnimation.isRemovedOnCompletion = false
            
            gradient.add(gradientAnimation, forKey: "colors")
        }
        func updateColorIndex(){
            if colorIndex < gradientColorSet.count - 1 {
                colorIndex += 1
            } else {
                colorIndex = 0
            }
        }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                view.showsFPS = true
                view.ignoresSiblingOrder = true
                view.showsNodeCount = true
            
            }
        }
}
     
 
