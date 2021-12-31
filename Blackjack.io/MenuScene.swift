//
//  MenuScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
// ID ca-app-pub-4889346564502252~7541718210
// Unit ID: ca-app-pub-4889346564502252/3842146359


import SpriteKit
import UIKit
import SwiftUI
import GoogleMobileAds

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        

        //backgroundColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
        print(frame.maxX)
        print(frame.maxY)
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
                print("1ER >LT")
            defaults.set(false, forKey: "FirstLaunch")
        }
    }
    
    
    
    
    func pressedButton (button: SKSpriteNode, time : CGFloat, scale : CGFloat, scaleBack : CGFloat) -> SKAction {
        
        let RectPressedAction1 = SKAction.scaleX(to: scale, duration: time/2)
        let RectPressedAction2 = SKAction.scaleY(to: scale, duration: time/2)
        
     
        let RectPressedAction3 = SKAction.scaleX(to: scaleBack, duration: time/2)
        let RectPressedAction4 = SKAction.scaleY(to: scaleBack, duration: time/2)
        
        let PressedRect = SKAction.run {
            button.run(RectPressedAction1)
            button.run(RectPressedAction2)
        }
        
        let UnpressedRect = SKAction.run {
            button.run(RectPressedAction3)
            button.run(RectPressedAction4)
        }
        let o = SKAction.wait(forDuration: 0.15)
        let RectPressedAction = SKAction.sequence([PressedRect,o,UnpressedRect])

        
        button.run(RectPressedAction)
        return(RectPressedAction)
    }
    
    
    
    
    func pressedNode (button: SKShapeNode, time : CGFloat) -> SKAction {
        
        let RectPressedAction1 = SKAction.scaleX(to: 0.6, duration: time/2)
        let RectPressedAction2 = SKAction.scaleY(to: 0.5, duration: time/2)
     
        let RectPressedAction3 = SKAction.scaleX(to: 1, duration: time/2)
        let RectPressedAction4 = SKAction.scaleY(to: 1, duration: time/2)
        
        let PressedRect = SKAction.run {
            button.run(RectPressedAction1)
            button.run(RectPressedAction2)
        }
        
        let UnpressedRect = SKAction.run {
            button.run(RectPressedAction3)
            button.run(RectPressedAction4)
        }
        let o = SKAction.wait(forDuration: 0.15)
        let RectPressedAction = SKAction.sequence([PressedRect,o,UnpressedRect])

        
        let waitAnimation = SKAction.wait(forDuration: 0.35)
        let SwitchScene = SKAction.run{(self.startgame())}
        
        let PressedbuttoN = SKAction.sequence([RectPressedAction,waitAnimation,SwitchScene])
        button.run(PressedbuttoN)
        return(RectPressedAction)
    }
    var CardsSpawned = false
    var soundImage : SKSpriteNode!
    var playRec : SKShapeNode!
    var borderRect : SKShapeNode!
    var playbutton : SKLabelNode!
    var CoinsValue = 500
    var newNode : SKSpriteNode!
    let fadeAction = SKAction.fadeAlpha(to: 0.95, duration: 0.2)
    let pressedAction = SKAction.scale(to: 0.7, duration: 0.3)
    
    func layerToSKSpritenode(layer : CALayer) -> SKSpriteNode {
        let view = UIView()
        layer.frame = self.frame
        view.layer.addSublayer(layer)
        UIGraphicsBeginImageContext(self.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        newNode = SKSpriteNode(texture: SKTexture(image: bgImage))

            
        return(newNode)
    }

        
        
    func MakeCGcolor(RED : CGFloat, GREEN : CGFloat,BLUE : CGFloat) -> CGColor {
        return(CGColor(red: RED/255, green: GREEN/255, blue: BLUE/255, alpha: 1.0))
    }


    func layoutScene(){
        let a = MakeCGcolor(RED: 10, GREEN: 10, BLUE: 27)
        let b = MakeCGcolor(RED: 15, GREEN: 25, BLUE: 56)
        let c = MakeCGcolor(RED: 24, GREEN: 40, BLUE: 76)

        let gradient = CAGradientLayer()
            gradient.type = .axial
            
            gradient.colors = [
                a,
                b,
                c
            ]
        gradient.removeFromSuperlayer()
        gradient.frame = self.view!.bounds


        let background = layerToSKSpritenode(layer: gradient)
        
        
        
        
        
        
        StartPlayerData()
        let previousLevel = defaults.integer(forKey: "UserLvl")
        let previousExp = defaults.integer(forKey: "UserExp")
        if defaults.integer(forKey: "UserExp") > (defaults.integer(forKey: "UserLvl") * 100){
         
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
        let expTaille = (pourcentage / 100 ) * (4*frame.maxX/5)
        
        
        soundImage = SKSpriteNode(imageNamed: "sound on")
        if defaults.bool(forKey: "soundon") == true {
            soundImage.texture = SKTexture(imageNamed: "sound on")
        }else if defaults.bool(forKey: "soundon") == false {
            soundImage.texture = SKTexture(imageNamed: "sound off")
        }
        soundImage.position = CGPoint(x: frame.minX + 60, y: frame.midY + 30)
        soundImage.xScale = 0.19
        soundImage.yScale = 0.19
        soundImage.name = "sound_image"
        
        
        
        let lvltext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvltext.position = CGPoint(x:frame.midX, y: (3.75 * (frame.maxY/5)))
        lvltext.fontSize = 20
        lvltext.text = "LEVEL \(defaults.integer(forKey: "UserLvl"))"
        let expText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        expText.position = CGPoint(x: frame.minX + 43, y: 7.7*(frame.maxY/9))
        expText.text = "\(Int(usexp))/\((Int(uselvl)) * 100)"
        expText.fontSize = 15
        
        
        
        let expBar = SKShapeNode(rectOf: CGSize(width: expTaille, height: 13), cornerRadius: 2)
        expBar.strokeColor = .clear
        expBar.fillColor = UIColor(red: 232/255, green: 233/255, blue: 243/255, alpha: 1)
        expBar.position = CGPoint(x: frame.midX , y: 8*(frame.maxY/9))
        expBar.lineWidth = CGFloat(2.5)
        expBar.zPosition = -10
        let bar = SKShapeNode(rectOf: CGSize(width: (4*frame.maxX/5.5), height: 20), cornerRadius: 9.5)
        bar.fillColor = .clear
        bar.lineWidth = CGFloat(3)
        bar.strokeColor = UIColor(red: 232/255, green: 233/255, blue: 243/255, alpha: 1)
        bar.position = CGPoint(x: frame.midX , y: 8*(frame.maxY/9))
        bar.zPosition = 10
        

                
            let backgroundTexture = SKTexture(imageNamed: "pen")
            /////////////////////let background = SKSpriteNode(texture: backgroundTexture)
        background.zPosition = -100
            background.position = CGPoint(x: frame.width/2, y: frame.height/2)
            addChild(background)
        

        func MenuCards(){
            var randInt = Int.random(in: 2...14)
            let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
            let randFamily = Int.random(in: 0...3)
            let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")
            let upperCard = SKSpriteNode(imageNamed: "backk")
            let bottomCard = SKSpriteNode(texture: RandomCardTexture)
            //upperCard.size = CGSize(width: frame.maxX/4.15, height: frame.maxY/6.5)//°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
            //bottomCard.size = CGSize(width: frame.maxX/4.25, height: frame.maxY/6.25)
            upperCard.xScale = 0.15
            upperCard.yScale = 0.13
            bottomCard.xScale = 0.15
            bottomCard.yScale = 0.13
            let yValue = 2*((frame.maxY / 1000)/3)
            upperCard.alpha = CGFloat(0.6)
            bottomCard.alpha = CGFloat(0.6)
            func swapCardSide(node: SKSpriteNode, texture : SKTexture){
                let swapCardSide = SKAction.run {
                    node.run(SKAction.scaleX(to: 0.2, duration: 0.1));///// REDUIT UN PEU LA CARTE
                    node.texture = texture;
                    node.run(SKAction.scaleX(to: -0.36, duration: 0))////////////// SPAWN CARTE EN MIROIR
                    node.run(SKAction.scaleX(to: -0.06, duration: 0.08))//////// RETOURNEMENT 1/2
                    node.run(SKAction.scaleX(to: 0.06, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
                    node.run(SKAction.scaleX(to: yValue, duration: 0.15))////////////// REMET A TAILLE NORMALE
                    
                }
                run(swapCardSide)
            }


            
            
            if CardsSpawned == false {

                bottomCard.position = CGPoint(x: frame.minX - 30, y: frame.midY - 50)
                upperCard.position = CGPoint(x: frame.maxX + 30, y: frame.midY + 50)
                addChild(upperCard)
                addChild(bottomCard)
                let upperMove = SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY + 53), duration: 0.15)
                let upperMoveBack = SKAction.move(to: CGPoint(x: frame.midX + 16 + (frame.maxX/10), y: frame.midY + 53), duration: 0.15)
                let xValue = frame.maxX / 1000

                
                
                let bottomMove = SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 53), duration: 0.15)
                let bottomMoveBack = SKAction.move(to: CGPoint(x: frame.midX - 16 - (frame.maxX/10), y: frame.midY - 53), duration: 0.15)
                
                let waitMove = SKAction.wait(forDuration: 0.22)
                                
                let Scaleup = SKAction.sequence([SKAction.scaleY(to: xValue	, duration: 0.2)])
                let AlphaBack = SKAction.fadeAlpha(to: 1 , duration: 1)

                let aa = SKAction.run {
                    self.run(SKAction.run {
                        upperCard.run(upperMove)
                    })
                }
                let bb = SKAction.run {
                    self.run(SKAction.run {
                        upperCard.run(upperMoveBack)
                    })
                }
                let wait1 = SKAction.wait(forDuration: 0.2)
                
                let cc = SKAction.run{
                    self.run(SKAction.run {
                        bottomCard.run(bottomMove)
                    })
                }
                let dd = SKAction.run{
                    self.run(SKAction.run {
                        bottomCard.run(bottomMoveBack)
                    })
                }
                
                let BottomSequence = SKAction.sequence([SKAction.run {
                    bottomCard.run(AlphaBack)
                },cc,SKAction.run {
                    bottomCard.run(Scaleup)
                } ,waitMove,SKAction.run {
                    swapCardSide(node: bottomCard, texture: SKTexture(imageNamed: "backk"))
                },waitMove,dd])
                
                let UpperSequence = SKAction.sequence([aa,SKAction.run {
                    upperCard.run(Scaleup)
                },waitMove,SKAction.run {
                    upperCard.run(AlphaBack)
                } ,SKAction.run {
                    swapCardSide(node: upperCard, texture: SKTexture(imageNamed: "\(Int.random(in: 2...14)) \(family[Int.random(in: 0...3)])"))
                },waitMove,bb])
                
             
                
                run(SKAction.sequence([BottomSequence,wait1,UpperSequence]))
            }
            
        }
        MenuCards()
        //addChild(bar)
        //addChild(expBar)
        addChild(expText)
        addChild(lvltext)
        //addChild(backgroundImage)
        addChild(soundImage)
    }
    
    func playbuttonFunc(){
        
        
        playbutton = SKLabelNode(fontNamed:"TextaW00-Heavy")
        playbutton.text = "PLAY"
        playbutton.name = "playbutton"
        playbutton.position = CGPoint(x: frame.midX, y: ((frame.maxY/5) - 12))
        playbutton.zPosition = 1
        playbutton.fontSize = 35
        
        playRec = SKShapeNode(rectOf: CGSize(width: 150, height: 55),cornerRadius: 23)
        playRec.name = "rectbutton"
        playRec.fillColor = UIColor(red: 49/255, green: 58/255, blue: 230/255, alpha: 1.0)
        playRec.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        playRec.lineWidth = CGFloat(3)
        playRec.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
        playRec.name = "playrectangle"
        
        borderRect = SKShapeNode(rectOf: CGSize(width: 150, height: 55),cornerRadius: 23)
        borderRect.name = "rectbutton"
        borderRect.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        borderRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        borderRect.lineWidth = CGFloat(3.3)
        borderRect.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
     
        //let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.6)
        //let scaleDownAction = SKAction.scale(to: 1, duration: 0.6)
        //let waitAction = SKAction.wait(forDuration: 0.2)
        //let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction, waitAction])
        //let repeatAction = SKAction.repeatForever(scaleActionSequence)
        //playbutton.run(repeatAction)
        addChild(playbutton)
        addChild(playRec)
        addChild(borderRect)
    }

    

    
    func blackjackpng(){
  
        //gradient.zPosition = -100
        //view?.layer.addSublayer(gradient)
        //view?.layer.insertSublayer(gradient,below: base )
        
        let blackjackText = SKLabelNode(fontNamed:"TextaW00-Heavy")
        blackjackText.xScale = 0.9
        blackjackText.yScale = 0.9
        blackjackText.text = "BLACKJACK.IO"
        blackjackText.position = CGPoint(x:frame.midX, y: (4 * (frame.maxY/5)))
        blackjackText.zPosition = 1
        let fade = SKAction.fadeAlpha(to: 0.1, duration: 0)
        let fadein = SKAction.fadeIn(withDuration: 1)
        let scaleup = SKAction.scale(to: 1.2, duration: 1)
        addChild(blackjackText)
        blackjackText.run(scaleup)
        blackjackText.run(SKAction.sequence([fade,fadein]))
    }
    
    func startgame(){
        let gameScene = GameScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .left, duration: 0.1)
        let reveal2 = SKTransition.doorway(withDuration: 1)
        gameScene.scaleMode = .aspectFill
        view!.presentScene(gameScene,transition: reveal2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {





        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "playrectangle"{
                    pressedNode(button: playRec, time: 0.7)
                }else if node.name == "sound_image"{
                    
                    pressedButton(button: soundImage, time: 0.3, scale: 0.12 , scaleBack: 0.19)
                    
                    if defaults.bool(forKey: "soundon") == true {
                        defaults.set(false, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound off")

                        
                    }else if defaults.bool(forKey: "soundon") == false {
                        defaults.set(true, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound on")
                        }
                }
            }
        }
    }
}
extension CAGradientLayer {

    func setColors(_ newColors: [CGColor],
                   animated: Bool = true,
                   withDuration duration: TimeInterval = 0,
                   timingFunctionName name: CAMediaTimingFunctionName? = nil) {

        if !animated {
            self.colors = newColors
            return
        }

        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = colors
        colorAnimation.toValue = newColors
        colorAnimation.duration = duration
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorAnimation.timingFunction = CAMediaTimingFunction(name: name ?? .linear)

        add(colorAnimation, forKey: "colorsChangeAnimation")
    }
}
