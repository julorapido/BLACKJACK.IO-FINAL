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
        Loading()
        
        let wait = SKAction.wait(forDuration: 1.85)
        run(SKAction.sequence([wait,SKAction.run{self.startgame()}]))
        
    }
    
    func startgame(){
        let Menuscene = MenuScene(size: view!.bounds.size)
        let f = SKTransition.crossFade(withDuration: 0.66)
        Menuscene.scaleMode = .aspectFill
        view!.presentScene(Menuscene,transition: f)
    }
    
    
    
    func LaunchNodes(){
  
        
        backgroundColor = UIColor(red: 15/255, green: 17/255, blue: 39/255, alpha: 1.0)
        
        let template = SKSpriteNode(texture: SKTexture(imageNamed: "templatee"))
        template.xScale = 0.4
        template.yScale = 0.4
        template.position = CGPoint(x: frame.midX, y: frame.midY)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let title = SKLabelNode(fontNamed: "TextaW00-Heavy")
        title.text = "BLACKJACK.IO ..."
        title.fontSize = 19
        title.position = CGPoint(x: frame.midX, y: 1*(frame.midY/5))
        
        
        
        
        
        
        addChild(title)
        addChild(template)
    }
    
    
    func Loading(){
        var leftnumber = 0
        var multiplicator = 1
        var familyList = ["CARREAU", "COEUR", "PIC", "TREFLE"]
        var index = 0
        
        var Renderedlist = [SKTexture]()
        for i in 1...52{
            if i > 4 * multiplicator {
                multiplicator += 1
                index = 0
            }
            Renderedlist.append(SKTexture(imageNamed: "\(multiplicator + 1) \(familyList[index])"))
            //print(Renderedlist)
            index += 1

        }
        Renderedlist.append(SKTexture(imageNamed: "HIT"))
        Renderedlist.append(SKTexture(imageNamed: "STAND"))
        Renderedlist.append(SKTexture(imageNamed: "gift"))
        Renderedlist.append(SKTexture(imageNamed: "backk"))
        Renderedlist.append(SKTexture(imageNamed: "blue deck"))

        for i in 1...10{
            Renderedlist.append(SKTexture(imageNamed: "COINS\(i)"))
        }

        for each in Renderedlist {
            each.preload {
                print("The texture is ready!")
            }
        }

    }
}
