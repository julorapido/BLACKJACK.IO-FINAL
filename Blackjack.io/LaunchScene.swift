//
//  LaunchScene.swift
//  Blackjack.io
//
//  Created by Jules Sainthorant on 08/01/2022.
//

import Foundation
import SpriteKit

class LaunchScreen: SKScene{
    override func didMove(to view: SKView) {
        LaunchNodes()
        
        
        let wait = SKAction.wait(forDuration: 1.5)
        run(SKAction.sequence([wait,SKAction.run{self.startgame()}]))
        
    }
    
    func startgame(){
        let Menuscene = MenuScene(size: view!.bounds.size)
        let f = SKTransition.crossFade(withDuration: 0.66)
        Menuscene.scaleMode = .aspectFill
        view!.presentScene(Menuscene,transition: f)
    }
    
    
    
    func LaunchNodes(){
        let title = SKLabelNode(fontNamed: "TextaW00-Heavy")
        title.text = "blackjack.io"
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        
        
        
        
        
        
        addChild(title)
    }
}
