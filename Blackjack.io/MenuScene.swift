//
//  MenuScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import SpriteKit
import UIKit
import SwiftUI

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        //backgroundColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)

        layoutScene()
        playbuttonFunc()
        blackjackpng()
        defaults.set(true, forKey: "FirstLaunch")
        defaults.synchronize()

        //for family: String in UIFont.familyNames{
        //    print(family)
        //}
        //for family: String in UIFont.familyNames
        //{
        //    print(family)
        //    for names: String in UIFont.fontNames(forFamilyName: family)
        //    {
        //        print("== \(names)")
        //  }

    }
        
    
    public let defaults = UserDefaults.standard
    public func intUserDefaults(value: Int, key: String){
        defaults.set(key, forKey: "\(key)")
    }
    let firstLaunch: Void = UserDefaults.standard.set(true, forKey: "FirstLaunch")
    func StartPlayerData(){
            if defaults.bool(forKey: "FirsLaunch") == true {
            intUserDefaults(value: 0, key: "UserExp")
            intUserDefaults(value: 1, key: "UserLvl")
            defaults.set(true, forKey: "soundon")
            
            defaults.set(false, forKey: "FirstLaunch")
        }
    }
    var soundImage : SKSpriteNode!
    var playRec : SKShapeNode!
    var playbutton : SKLabelNode!
    var CoinsValue = 500
    let fadeAction = SKAction.fadeAlpha(to: 0.1, duration: 0.2)
    let pressedAction = SKAction.scale(to: 0.7, duration: 0.3)
    let RectPressedAction = SKAction.scale(to: CGSize(width: 95, height: 45), duration: 0.3)
    func layoutScene(){
        StartPlayerData()
        let previousLevel = defaults.integer(forKey: "UserLvl")
        let previousExp = defaults.integer(forKey: "UserExp")
        if defaults.integer(forKey: "UserExp") > (defaults.integer(forKey: "UserLvl") * 100){
            print("Level up")
         
            defaults.set(previousExp - previousLevel * 100 , forKey: "UserExp")
        }
        //defaults.integer(forKey: "UserExp")
        //var p = CGFloat()
        //var percent : CGFloat = defaults.CGfloat(forKey: "UserExp")
        //var backgroundsTextures : [SKTexture] = []
        //for i in 1...6 {
        //    backgroundsTextures.append(SKTexture(imageNamed:"background\(i)"))
        //}
        //let backgroundAnimation = SKAction.animate(with: backgroundsTextures,timePerFrame: 0.08)
        //let background = SKSpriteNode(imageNamed: "background1")
        //background.size = CGSize(width: frame.maxX, height: frame.maxY)
        //let backgroundInfinite = SKAction.repeatForever(backgroundAnimation)
        //background.position = CGPoint(x : frame.midX,y: frame.midY)
        //background.run(backgroundInfinite)
        let usexp = defaults.double(forKey: "UserExp")
        let uselvl = defaults.double(forKey: "UserLvl")
        let expNeeded = uselvl * 100
        let pourcentage = (usexp / expNeeded) * 100
        let expTaille = (pourcentage / 100 ) * (frame.maxX - 45)
        
        
        soundImage = SKSpriteNode(imageNamed: "sound on")
        if defaults.bool(forKey: "soundon") == true {
            soundImage.texture = SKTexture(imageNamed: "sound on")
        }else if defaults.bool(forKey: "soundon") == false {
            soundImage.texture = SKTexture(imageNamed: "sound off")
        }
        soundImage.position = CGPoint(x: frame.minX + 60, y: frame.midY + 30)
        soundImage.xScale = 0.25
        soundImage.yScale = 0.25
        soundImage.name = "sound_image"
        
        
        let lvltext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvltext.position = CGPoint(x: frame.maxX - 43, y: frame.maxY - 86)
        lvltext.fontSize = 15
        lvltext.text = "LVL \(defaults.integer(forKey: "UserLvl"))"
        let expText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        expText.position = CGPoint(x: frame.minX + 43, y: frame.maxY - 86)
        expText.text = "\(Int(usexp))/\((Int(uselvl)) * 100)"
        expText.fontSize = 15
        
        
        
        
        let stand = SKSpriteNode(imageNamed: "stand")
        stand.xScale = 0.7
        stand.yScale = 0.7
        stand.position = CGPoint(x: frame.midX, y: frame.midY + 55)
        let hit = SKSpriteNode(imageNamed: "hit")
        hit.xScale = 0.7
        hit.yScale = 0.7
        hit.position = CGPoint(x: frame.midX , y: frame.midY)
        
        let expBar = SKShapeNode(rectOf: CGSize(width: expTaille, height: 13), cornerRadius: 2)
        expBar.strokeColor = .clear
        expBar.fillColor = UIColor(red: 232/255, green: 233/255, blue: 243/255, alpha: 1)
        expBar.position = CGPoint(x: frame.midX , y: frame.maxY - 50)
        expBar.lineWidth = CGFloat(2.5)
        expBar.zPosition = -10
        let bar = SKShapeNode(rectOf: CGSize(width: frame.maxX - 45, height: 20), cornerRadius: 9.5)
        bar.fillColor = .clear
        bar.lineWidth = CGFloat(3)
        bar.strokeColor = UIColor(red: 232/255, green: 233/255, blue: 243/255, alpha: 1)
        bar.position = CGPoint(x: frame.midX , y: frame.maxY - 50)
        bar.zPosition = 10
        
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "pen")
        backgroundImage.zPosition = -100
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.xScale = 0.5
        backgroundImage.yScale = 0.48
        let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX, height: frame.midY))
        rect.position = CGPoint(x: frame.midX, y: frame.minY)
        rect.fillColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
        rect.strokeColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
        addChild(bar)
        addChild(expBar)
        addChild(hit)
        addChild(stand)
        addChild(expText)
        addChild(lvltext)
        addChild(backgroundImage)
        addChild(soundImage)
    }
    
    func playbuttonFunc(){
        
        
        playbutton = SKLabelNode(fontNamed:"TextaW00-Heavy")
        playRec = SKShapeNode(rectOf: CGSize(width: 137, height: 62),cornerRadius: 8)
        playRec.name = "rectbutton" 
        playRec.fillColor = UIColor(red: 49/255, green: 168/255, blue: 218/255, alpha: 1.0)
        playRec.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        playRec.lineWidth = CGFloat(3)
        playRec.position = CGPoint(x: frame.midX, y: (frame.maxY/4))
        
        playRec.name = "playrectangle"
        playbutton.text = "PLAY"
        playbutton.name = "playbutton"
        playbutton.position = CGPoint(x: frame.midX, y: ((frame.maxY/4) - 12))
        playbutton.zPosition = 1
        playbutton.fontSize = 40
        //let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.6)
        //let scaleDownAction = SKAction.scale(to: 1, duration: 0.6)
        //let waitAction = SKAction.wait(forDuration: 0.2)
        //let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction, waitAction])
        //let repeatAction = SKAction.repeatForever(scaleActionSequence)
        //playbutton.run(repeatAction)
        addChild(playbutton)
        addChild(playRec)
    }
    
    func playerCoins(){
        //let coins = SKLabelNode(fontNamed:"Rust")
        //var CoinsText = UserDefaults.value(forKey: "UserCoins")
        //coins.text = CoinsText
    }
    
    
    
    func blackjackpng(){
        let blackjackText = SKLabelNode(fontNamed:"TextaW00-Heavy")
        blackjackText.xScale = 0.75
        blackjackText.yScale = 0.75
        blackjackText.text = "BLACKJACK.IO"
        blackjackText.position = CGPoint(x:frame.midX, y: (3 * (frame.maxY/4)))
        blackjackText.zPosition = 1
        let fade = SKAction.fadeAlpha(to: 0.1, duration: 0)
        let fadein = SKAction.fadeIn(withDuration: 1.2)
        let scaleup = SKAction.scale(to: 1, duration: 1.2)
        addChild(blackjackText)
        blackjackText.run(scaleup)
        blackjackText.run(SKAction.sequence([fade,fadein]))
    }
    
    func startgame(){
        let gameScene = GameScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .left, duration: 0.1)
        gameScene.scaleMode = .aspectFill
        view!.presentScene(gameScene,transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let fadeOut = SKAction.sequence([  SKAction.run{(self.playRec.run(self.fadeAction))},SKAction.run {
            (self.playRec.run(self.RectPressedAction))
        },  SKAction.run{(self.playbutton.run(self.fadeAction))}, SKAction.run{(self.playbutton.run(self.pressedAction))} ])
        let waitAnimation = SKAction.wait(forDuration: 0.2)
        let SwitchScene = SKAction.run{(self.startgame())}
        let PressedbuttoN = SKAction.sequence([fadeOut,waitAnimation,SwitchScene])
        
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "playrectangle"{
                    node.run(PressedbuttoN)
                }else if node.name == "sound_image"{
                    print(defaults.bool(forKey: "soundon"))
                    if defaults.bool(forKey: "soundon") == true {
                        defaults.set(false, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound off")

                        
                    }else if defaults.bool(forKey: "soundon") == false {
                        defaults.set(true, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound on")
                        }
                    print("sound :"+String(defaults.bool(forKey: "soundon")))

                }
            }
        }
    }
}
