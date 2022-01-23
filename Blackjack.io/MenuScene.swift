//
//  MenuScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
// ID ca-app-pub-4889346564502252~7541718210
// Unit ID: ca-app-pub-4889346564502252/3842146359


import SpriteKit
import UIKit
import Foundation
import AVFoundation
//import GoogleMobileAds
//MAX X IPHONE 8 : 375
// MAX X IPHONE 8 PLUS : 414
class MenuScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        defaults.set(false, forKey: "FIRSTEVERLAUNCH")
        print("Menu lasvictory : \(defaults.bool(forKey: "LastGameVictory?"))")
        var CoinsTexture:[SKTexture] = []
        for i in 1...10 {
            CoinsTexture.append(SKTexture(imageNamed: "COINS\(i)"))
        }
        if defaults.bool(forKey: "MusicOn?") == true {
            if defaults.bool(forKey: "MUSICEVERLAUNCHED") == false {
                BackgroundMusic()
                defaults.set(true, forKey: "MUSICEVERLAUNCHED")
            }
        }
        layoutScene()
        playbuttonFunc()
        blackjackpng()
        AnimateCoins(TimeInterval: 0.1)
        if defaults.bool(forKey: "FirstLaunch") == true {
            AdustNodeApparitions()
        }
        if defaults.bool(forKey: "LastGameVictory?") == true{
            LastGameVictory()
        }
    }
        

    public let defaults = UserDefaults.standard

    
    var background : SKSpriteNode!

    var MUSIClaunched = false
    
    var usexp : Double!
    var uselvl : Double!
    var UserCoins : Int!
    var MusicPlayer: AVAudioPlayer!

    var expNeeded : Double!
    
    func UserData() {

        
        if defaults.integer(forKey: "UserExp") > (defaults.integer(forKey: "UserLvl") * 100){
            LevelUp()
        }
        usexp = defaults.double(forKey: "UserExp")
        uselvl = defaults.double(forKey: "UserLvl")
        expNeeded = uselvl * 100
        UserCoins = defaults.integer(forKey: "UserCoins")

    }
    func BackgroundMusic(){
        if let r = Bundle.main.path(forResource: "MainMusic", ofType: "mp3"){
            let bgmusic = NSURL(fileURLWithPath: r)
            do {
                MusicPlayer = try AVAudioPlayer(contentsOf: bgmusic as URL)
                guard let MusicPlayer = MusicPlayer else {return}
                MusicPlayer.numberOfLoops = -1
                MusicPlayer.prepareToPlay()
                MusicPlayer.play()
            } catch {
                print(error)
            }
        }
        MUSIClaunched = true
    }
    func LastGameVictory(){
        print("pupupute")
        let ApparitionRect = SKShapeNode(rectOf: CGSize(width: 105, height: 32.5), cornerRadius: 10)
        ApparitionRect.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        ApparitionRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        ApparitionRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        ApparitionRect.zPosition = 2
        ApparitionRect.lineWidth = CGFloat(2.5)

        ApparitionRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))

        
        let AppearCoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
        AppearCoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        AppearCoinsRect.fillColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.strokeColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.lineWidth = CGFloat(5)
        AppearCoinsRect.zPosition = 2
        addChild(AppearCoinsRect)
        addChild(ApparitionRect)

        AppearCoinsRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))
    }
    
    func Particles(XValue : CGPoint){
        var exodeX = CGFloat(30)
        var exodeY = CGFloat(10)
        let zizou = Int.random(in: 1...2)
        let zizou2 = Int.random(in: 1...2)
        var rotateValue : Double!
        if zizou == 1 {
            exodeX = -(exodeX)
            rotateValue = M_PI/4
        }else if zizou == 2{
            exodeY = -(exodeY)
            rotateValue = -M_PI/4

        }
            
    
        let exodeAction = SKAction.move(by: CGVector(dx: exodeX, dy: exodeY), duration: 2.6)
        let fadeSequence = SKAction.sequence([SKAction.fadeAlpha(to: 0.7, duration: 1.3),SKAction.fadeAlpha(to: 0, duration: 1.3)])
        let square = SKShapeNode(rectOf: CGSize(width: 4, height: 4))
        let rotating = SKAction.rotate(byAngle: rotateValue, duration: 2)
        let scaleSequence = SKAction.sequence([SKAction.scale(by: 1.3, duration: 1),SKAction.scale(by: 0.6, duration: 1)])
        square.fillColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        square.strokeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        square.alpha = 0.2

        square.zPosition = -99
     
        
        let randomValue = Int.random(in: 1...30)
        let fdp = CGFloat(randomValue)
            square.position = CGPoint(x: XValue.x + fdp, y: XValue.y + fdp)
            addChild(square)
            square.run(exodeAction)
        square.run(fadeSequence)
        square.run(rotating)
        square.run(scaleSequence)
        square.run(SKAction.sequence([SKAction.wait(forDuration: 5),SKAction.run{self.removeFromParent()}]))
        
    }
    func LevelUp(){
        let previousLevel = defaults.integer(forKey: "UserLvl")
        let previousExp = defaults.integer(forKey: "UserExp")
        defaults.set(previousLevel + 1, forKey: "UserLvl")
        defaults.set(previousExp - (previousLevel * 100), forKey: "UserExp")
    
    }
    
    func pressedButton (button: SKSpriteNode, time : CGFloat, scale : CGFloat) -> SKAction {
        
        var buttonScaleBackValue = button.xScale
        
        let RectPressedAction1 = SKAction.scaleX(to: scale, duration: time/2)
        let RectPressedAction2 = SKAction.scaleY(to: scale, duration: time/2)
        
     
        let RectPressedAction3 = SKAction.scaleX(to: buttonScaleBackValue, duration: time/2)
        let RectPressedAction4 = SKAction.scaleY(to: buttonScaleBackValue, duration: time/2)
        
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
    var SkinShopTouched = false
    var mainrect : SKShapeNode!
    var expRect : SKShapeNode!
    var expText : SKLabelNode!
    var CoinsRect : SKShapeNode!
    var CoinsText : SKLabelNode!
    var GiftText : SKLabelNode!
    var GiftImage : SKSpriteNode!
    var CardsSpawned = false
    var soundImage : SKSpriteNode!
    var playRec : SKShapeNode!
    var borderRect : SKShapeNode!
    var playbutton : SKLabelNode!
    var Coins : SKSpriteNode!
    var SkinShop : SKSpriteNode!
    var newNode : SKSpriteNode!
    let fadeAction = SKAction.fadeAlpha(to: 0.95, duration: 0.2)
    let pressedAction = SKAction.scale(to: 0.7, duration: 0.3)
    var musicImage :SKSpriteNode!
    
    var slot1 : Any!
    var slot2 : Any!
    var slot3 : Any!
    var slot4 : Any!
    var slot5 : Any!
    var slot6 : Any!
    var slot7 : Any!
    var slot8 : Any!
    var slot9 : Any!
    
    

    func disableUserInter(time :Double){
        let disable = SKAction.run {
            self.isUserInteractionEnabled = false
        }
        let waitTime = SKAction.wait(forDuration: time)
        let enable = SKAction.run {
            self.isUserInteractionEnabled = true
        }
        run(SKAction.sequence([disable,waitTime,enable]))
    }
    
    
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

    func addSkinSlot(Position : CGPoint, SkinTexture : SKTexture, NodeName : String, SkinCheckbox : SKTexture) -> (SKShapeNode, SKSpriteNode){
        let outerRectangle = SKShapeNode(rectOf: CGSize(width: 72, height: 80), cornerRadius: 10)
        outerRectangle.lineWidth = CGFloat(3)
        outerRectangle.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
        outerRectangle.position = CGPoint(x: Position.x, y: Position.y + 60)
        outerRectangle.zPosition = 16
        let checkbox = SKSpriteNode(texture: SkinCheckbox)
        checkbox.xScale = 0.2
        checkbox.yScale = 0.2
        checkbox.alpha = 0
        outerRectangle.alpha = 0
        checkbox.zPosition = 16
        addChild(outerRectangle)
        addChild(checkbox)
        checkbox.run(SKAction.fadeIn(withDuration: 0.3))
        outerRectangle.run(SKAction.fadeIn(withDuration: 0.3))

        checkbox.position = Position
        outerRectangle.name = "shopnode"
        checkbox.name = "shopnode"
        return(outerRectangle,checkbox)
    }
   
    func sida(rect : SKShapeNode){
        addChild(rect)
    }
    class SKINslot{
        
    }
    class AddSkinSlot{
        var positionn : CGPoint!
        var SkinTexture : SKTexture!
        var skincheckbox : SKTexture!
        var SlotUnlocked : Bool!
        var checkbox : SKSpriteNode!
        var OuterRectangle = SKShapeNode(rectOf: CGSize(width: 72, height: 80), cornerRadius: 10)
        //ar checkbox : SKSpriteNode!
        var Menusenee = MenuScene()
        
        init(Position : CGPoint, SkinTexture : SKTexture, NodeName : String, SkinCheckbox : SKTexture){
            positionn = Position
            let outerRectangle = SKShapeNode(rectOf: CGSize(width: 72, height: 80), cornerRadius: 10)
            outerRectangle.lineWidth = CGFloat(3)
            outerRectangle.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
            outerRectangle.position = CGPoint(x: positionn.x, y: positionn.y + 60)
            outerRectangle.zPosition = 309
            let checkbox = SKSpriteNode(texture: SkinCheckbox)
            checkbox.xScale = 0.2
            checkbox.yScale = 0.2
            checkbox.alpha = 1
            outerRectangle.alpha = 1
            checkbox.zPosition = 16

            checkbox.run(SKAction.fadeIn(withDuration: 0.3))
            outerRectangle.run(SKAction.fadeIn(withDuration: 0.3))
            print("PEDALE")
            checkbox.position = positionn
            outerRectangle.name = "shopnode"
            checkbox.name = "shopnode"
        }
        func addChilds(){
            self.Menusenee.addChild(checkbox)
            self.Menusenee.addChild(OuterRectangle)
        }
    }
    func SkinShopFunc(){
        SkinShopTouched = true
        slot9 = AddSkinSlot(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot9", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot9")!))
        
        mainrect = SKShapeNode(rectOf: CGSize(width: 4.5*(frame.maxX/5), height: 3.4*(frame.maxY/5)), cornerRadius: 10)
        mainrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        mainrect.zPosition = 15
        mainrect.name = "shopnode"
        mainrect.alpha = CGFloat(0)
        mainrect.lineWidth = CGFloat(3)
        mainrect.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(mainrect)
        mainrect.run(SKAction.fadeIn(withDuration: 0.3))
        //slot9 = addSkinSlot(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot9", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot9")!))
        slot8 = addSkinSlot(Position: CGPoint(x: 3*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot8", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot8")!))
        slot7 = addSkinSlot(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot7", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot7")!))
        
        slot6 = addSkinSlot(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot6", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot6")!))
        slot5 = addSkinSlot(Position: CGPoint(x: 3*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot5", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot5")!))
        slot4 = addSkinSlot(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot4", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot4")!))

        slot1 = addSkinSlot(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot3", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot1")!))
        slot2 = addSkinSlot(Position: CGPoint(x: 3*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot2", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot2")!))
        slot3 = addSkinSlot(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), NodeName: "Slot1", SkinCheckbox: SKTexture(imageNamed: defaults.string(forKey: "Slot3")!))

    }
        
    func MakeCGcolor(RED : CGFloat, GREEN : CGFloat,BLUE : CGFloat) -> CGColor {
        return(CGColor(red: RED/255, green: GREEN/255, blue: BLUE/255, alpha: 1.0))
    }


    func layoutScene(){
        UserData()

        let a = MakeCGcolor(RED: 0, GREEN: 14, BLUE: 29)
        let b = MakeCGcolor(RED: 0, GREEN: 23, BLUE: 45)
        let c = MakeCGcolor(RED: 0, GREEN: 38 , BLUE: 77)



        let gradient = CAGradientLayer()
            gradient.type = .axial
            
            gradient.colors = [
                a,
                b,
                c
                
            ]
        gradient.removeFromSuperlayer()
        gradient.frame = self.view!.bounds


         background = layerToSKSpritenode(layer: gradient)
        

        
        soundImage = SKSpriteNode(imageNamed: "sound on")
        if defaults.bool(forKey: "soundon") == true {
            soundImage.texture = SKTexture(imageNamed: "sound on")
        }else if defaults.bool(forKey: "soundon") == false {
            soundImage.texture = SKTexture(imageNamed: "sound off")
        }
        soundImage.position = CGPoint(x: frame.minX + 55, y: 14.75*(frame.maxY/20))
        soundImage.xScale = 0.065
        soundImage.yScale = 0.065
        soundImage.name = "sound_image"
        
        musicImage = SKSpriteNode(imageNamed: "musicon")
        if defaults.bool(forKey: "MusicOn?") == true {
            musicImage.texture = SKTexture(imageNamed: "musicon")
        }else if defaults.bool(forKey: "MusicOn?") == false {
            musicImage.texture = SKTexture(imageNamed: "musicoff")
        }
        musicImage.xScale = 0.07
        musicImage.yScale = 0.07
        musicImage.name = "music_image"
        
        SkinShop = SKSpriteNode(imageNamed: "shop")
        SkinShop.xScale = 0.1
        SkinShop.yScale = 0.1
        SkinShop.name = "skinshop_image"
        
        GiftImage = SKSpriteNode(imageNamed: "gift")
        GiftImage.xScale = 0.12
        GiftImage.yScale = 0.12
        GiftImage.name = "gift_image"
        GiftImage.position = CGPoint(x: 5*(frame.maxX/6), y: 1.2*(frame.maxY/3))

        
        GiftText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        GiftText.text = "FREE COINS +10"
        GiftText.position = CGPoint(x: 5*(frame.maxX/6), y: 1*(frame.maxY/3))
        GiftText.fontSize = 14
        
        
        
        func SideButtons(Scaling : CGFloat){
            musicImage.xScale = Scaling
            musicImage.yScale = Scaling
            soundImage.xScale = Scaling - CGFloat(0.01)
            soundImage.yScale = Scaling - CGFloat(0.01)
            SkinShop.xScale = Scaling/2
            SkinShop.yScale = Scaling/2
        }
        
        let lvltext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvltext.position = CGPoint(x:frame.midX, y: (3.9 * (frame.maxY/5)))
        lvltext.fontSize = 20
        lvltext.text = "LEVEL \(defaults.integer(forKey: "UserLvl"))"
        
        let lvlrect = SKShapeNode(rectOf: CGSize(width: 100, height: 30), cornerRadius: 10)
        lvlrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.position = CGPoint(x:frame.midX, y: (3.95 * (frame.maxY/5)))

        
        expText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        expText.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.85*(frame.maxY/9))
        expText.text = "EXP  \(Int(usexp))|\((Int(uselvl)) * 100)"
        expText.fontSize = 15
        expText.zPosition = 5
        
        expRect = SKShapeNode(rectOf: CGSize(width: 100, height: 30), cornerRadius: 10)
        expRect.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        expRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        expRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        expRect.zPosition = 4
        
        
        
        musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
        SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
        soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
        
                
            //let backgroundTexture = SKTexture(imageNamed: "pen")
            /////////////////////let background = SKSpriteNode(texture: backgroundTexture)
        background.zPosition = -100
            background.position = CGPoint(x: frame.width/2, y: frame.height/2)
            addChild(background)
        
        
            
        let coinsInt = defaults.integer(forKey: "UserCoins")
        CoinsText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
        CoinsText.text = "\(coinsInt)"
        CoinsText.fontSize = 20
        CoinsText.zPosition = 5
        CoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
        CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.zPosition = 4
        Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        Coins.zPosition = 20
        Coins.position = CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.01))
        

        addChild(Coins)
        addChild(CoinsText)
        addChild(CoinsRect)
        addChild(lvlrect)
        
        
        func MenuCards(){
            var randInt = Int.random(in: 2...14)
            let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
            let randFamily = Int.random(in: 0...3)
            let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")
            let upperCard = SKSpriteNode(imageNamed: "backk")
            let bottomCard = SKSpriteNode(texture: RandomCardTexture)
            //upperCard.size = CGSize(width: frame.maxX/4.15, height: frame.maxY/6.5)//
            //bottomCard.size = CGSize(width: frame.maxX/4.25, height: frame.maxY/6.25)
            upperCard.xScale = 0.15
            upperCard.yScale = 0.13
            bottomCard.xScale = 0.15
            bottomCard.yScale = 0.13
            let yValue = 3*((frame.maxY / 1000)/4)
            var AdaptiveValue : CGFloat!
            if (frame.maxY) <= CGFloat(580){///////////////// IPOD
                AdaptiveValue = CGFloat(0.45)
                SideButtons(Scaling: 0.2)
                
            }else if (frame.maxY) > CGFloat(600) && (frame.maxY) < CGFloat(730){///////////////// IPHONE 7 8
                AdaptiveValue = CGFloat(0.52)
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.4*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.05*(frame.maxY/20))
                SideButtons(Scaling: 0.18)
            }else if (frame.maxY) > CGFloat(736) && (frame.maxY) < CGFloat(900){////////////////// IPHONE XR 11 12 13
                AdaptiveValue = CGFloat(0.55)
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
                SideButtons(Scaling: 0.2)
            }else if (frame.maxY) > CGFloat(900){///////////// IPHONE MAX 13 MAX 12 MAX
                AdaptiveValue = CGFloat(0.585)
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
                SideButtons(Scaling: 0.21)
            }
            upperCard.alpha = CGFloat(0.6)
            bottomCard.alpha = CGFloat(0.6)
            func swapCardSide(node: SKSpriteNode, texture : SKTexture){
                let swapCardSide = SKAction.run {
                    node.run(SKAction.scaleX(to: 0.2, duration: 0.26));///// REDUIT UN PEU LA CARTE
                    node.texture = texture;
                    node.run(SKAction.scaleX(to: -0.36, duration: 0))////////////// SPAWN CARTE EN MIROIR
                    node.run(SKAction.scaleX(to: -0.06, duration: 0.26))//////// RETOURNEMENT 1/2
                    node.run(SKAction.scaleX(to: 0.06, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
                    node.run(SKAction.scaleX(to: AdaptiveValue, duration: 0.26))////////////// REMET A TAILLE NORMALE
                    
                }
                run(swapCardSide)
            }


            
            
            if CardsSpawned == false {

                bottomCard.position = CGPoint(x: frame.minX - 30, y: frame.midY - 50)
                upperCard.position = CGPoint(x: frame.maxX + 30, y: frame.midY + 50)
                bottomCard.zPosition = 3
                upperCard.zPosition = 2
                addChild(upperCard)
                addChild(bottomCard)
                let upperMove = SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY + 53), duration: 0.15)
                let upperMoveBack = SKAction.move(to: CGPoint(x: frame.midX + 16 + (frame.maxX/10), y: frame.midY + 58), duration: 0.15)
                let xValue = frame.maxX / 1000

                
                
                let bottomMove = SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 53), duration: 0.15)
                let bottomMoveBack = SKAction.move(to: CGPoint(x: frame.midX - 16 - (frame.maxX/10), y: frame.midY - 58), duration: 0.15)
                
                let waitMove = SKAction.wait(forDuration: 0.22)
                                
                let Scaleup = SKAction.sequence([SKAction.scaleY(to: 1.2*(xValue)	, duration: 0.2)])
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
        //oins()
        addChild(expRect)
        addChild(expText)
        addChild(lvltext)
        
        let wait4 = SKAction.wait(forDuration: 4.25)
        let wait5 = SKAction.wait(forDuration: 3.9)
        let wait3 = SKAction.wait(forDuration: 3.2)
        let e = SKAction.run{self.Particles(XValue: CGPoint(x: self.frame.midX, y: self.frame.midY))}
        let f = SKAction.run{self.Particles(XValue: CGPoint(x: 2*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let t = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4.6*(self.frame.maxY/5)))}
        let y = SKAction.run{self.Particles(XValue: CGPoint(x: 3.4*(self.frame.maxX/5), y: 3.5*(self.frame.maxY/5)))}
        let p = SKAction.run{self.Particles(XValue: CGPoint(x: 0.7*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let pp = SKAction.run{self.Particles(XValue: CGPoint(x: 0.4*(self.frame.maxX/5), y: 1.6*(self.frame.maxY/5)))}

        
        let o = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}
        let oo = SKAction.run{self.Particles(XValue: CGPoint(x: 3.5*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}

        let i = SKAction.run{self.Particles(XValue: CGPoint(x: 1.5*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        let ii = SKAction.run{self.Particles(XValue: CGPoint(x: 3.25*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        
        let pd = SKAction.run{self.Particles(XValue: CGPoint(x: 2.1*(self.frame.maxX/5), y: 3.7*(self.frame.maxY/10)))}
        
        let z = SKAction.run{self.Particles(XValue: CGPoint(x: 4.4*(self.frame.maxX/5), y: 9*(self.frame.maxY/10)))}
        run(SKAction.repeatForever(SKAction.sequence([wait4,e])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,f])))
        run(SKAction.repeatForever(SKAction.sequence([t,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,y])))
        run(SKAction.repeatForever(SKAction.sequence([i,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,ii])))
        run(SKAction.repeatForever(SKAction.sequence([o,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([oo,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([p,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([pp,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([z,wait3])))
        run(SKAction.repeatForever(SKAction.sequence([pd,wait3])))







        addChild(soundImage)
        addChild(musicImage)
        addChild(SkinShop)
        addChild(GiftImage)
        addChild(GiftText)
    }
    
    func playbuttonFunc(){
        
        
        playbutton = SKLabelNode(fontNamed:"TextaW00-Heavy")
        playbutton.text = "PLAY"
        playbutton.name = "playbutton"
        playbutton.position = CGPoint(x: frame.midX, y: ((frame.maxY/5) - 12))
        playbutton.zPosition = 3
        playbutton.fontSize = 35
        
        playRec = SKShapeNode(rectOf: CGSize(width: 140, height: 50),cornerRadius: 10)
        playRec.name = "rectbutton"
        playRec.fillColor = UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1.0)
        playRec.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        playRec.lineWidth = CGFloat(3)
        playRec.zPosition = 2
        playRec.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
        playRec.name = "playrectangle"
        
        borderRect = SKShapeNode(rectOf: CGSize(width: 140, height: 50),cornerRadius: 10)
        borderRect.name = "rectbutton"
        borderRect.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        borderRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        borderRect.lineWidth = CGFloat(5)
        borderRect.zPosition = 1
        borderRect.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
     

        let fadeDown = SKAction.fadeAlpha(to: 0.5, duration: 0.72)
        let fadeUp = SKAction.fadeAlpha(to: 1, duration: 0.72)
        let fadeeActionSequence = SKAction.sequence([fadeDown,fadeUp])
        let repeatAction = SKAction.repeatForever(fadeeActionSequence)
        borderRect.run(repeatAction)
        addChild(playbutton)
        addChild(playRec)
        addChild(borderRect)
    }

    func  AdustNodeApparitions() {
        
        
        
        CoinsRect.position = CGPoint(x: frame.minX - 60, y: 0.9*(frame.maxY/9))
        CoinsText.position = CGPoint(x: frame.minX - 60, y: 0.81*(frame.maxY/9))
        Coins.position = CGPoint(x: frame.minX - 60, y: 0.91*(frame.maxY/9))
        Coins.alpha = CGFloat(0.1)
        CoinsText.alpha = CGFloat(0.1)
        CoinsRect.alpha = CGFloat(0.1)
        
        let text = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
        let rect = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        let coin = CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        let moveAction1 = SKAction.move(to: text, duration: 0.75)
        let moveAction2 = SKAction.move(to: rect, duration: 0.75)
        let moveAction3 = SKAction.move(to: coin, duration: 0.75)
        let fadeAction = SKAction.fadeAlpha(to: 1, duration: 1.5)
        CoinsRect.run(moveAction2)
        CoinsText.run(moveAction1)
        Coins.run(moveAction3)
        CoinsRect.run(fadeAction)
        CoinsText.run(fadeAction)
        Coins.run(fadeAction)
        
        
        
        expText.position = CGPoint(x: frame.maxX + 40, y: 0.85*(frame.maxY/9))
        expRect.position = CGPoint(x: frame.maxX + 40, y: 0.91*(frame.maxY/9))
        expRect.alpha = CGFloat(0.1)
        expText.alpha = CGFloat(0.1)
        let exprectt = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        let expTextt = CGPoint(x: 3.25*(frame.maxX/4), y: 0.85*(frame.maxY/9))
        let moveActionn1 = SKAction.move(to: exprectt, duration: 0.8)
        let moveActionn2 = SKAction.move(to: expTextt, duration: 0.8)
        expText.run(moveActionn2)
        expRect.run(moveActionn1)
        expText.run(fadeAction)
        expRect.run(fadeAction)
        
        playbutton.alpha = CGFloat(0)
        playRec.alpha = CGFloat(0)
        borderRect.alpha = CGFloat(0)
        let fadeAction2 = SKAction.fadeAlpha(to: 1, duration: 1)
        playbutton.run(fadeAction2)
        playRec.run(fadeAction2)
        borderRect.run(fadeAction2)
    }

    func blackjackpng(){
  
        
        let blackjackText = SKLabelNode(fontNamed:"TextaW00-Heavy")
        blackjackText.xScale = 0.9
        blackjackText.yScale = 0.9
        blackjackText.text = "BLACKJACK.IO"
        blackjackText.position = CGPoint(x:frame.midX, y: (4.25 * (frame.maxY/5)))
        blackjackText.zPosition = 1
        let fade = SKAction.fadeAlpha(to: 0.1, duration: 0)
        let fadein = SKAction.fadeIn(withDuration: 1)
        let scaleup = SKAction.scale(to: 1.2, duration: 1)
        addChild(blackjackText)
        blackjackText.run(scaleup)
        blackjackText.run(SKAction.sequence([fade,fadein]))
        
        
    }
    func AnimateCoins(TimeInterval : CGFloat){
        let wait = SKAction.wait(forDuration: TimeInterval)
        let Animation = SKAction.sequence([
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS2")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS3")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS4")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS5")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS6")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS7")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS8")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS9")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS10")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS1")})
        

        
        ])
        let loop = SKAction.sequence([Animation])
        let final = SKAction.repeatForever(loop)
        Coins.run(final)
        
    }
    
    func startgame(){
        let gameScene = GameScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .left, duration: 0.1)
        let reveal2 = SKTransition.doorway(withDuration: 1)
        gameScene.scaleMode = .aspectFill
        view!.presentScene(gameScene,transition: reveal)
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            if SkinShopTouched == true {
                playRec.run(SKAction.run {
                    self.playRec.isUserInteractionEnabled = false
                })
                if mainrect.frame.contains(location){
                    print(slot9)
                    print("LA PUTE LA PUTE")
                }else{
                    for child in self.children {
                        if child.name == "shopnode"{
                            child.run(SKAction.fadeOut(withDuration: 0.2))
                            child.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run{child.removeFromParent()}]))
                        }
                    }
                }
            }
            for node in touchedNode {
                if node.name == "playrectangle"{
                    let waitAnimation = SKAction.wait(forDuration: 0.35)
                    let SwitchScene = SKAction.run{(self.startgame())}
                    let PressedbuttoN = SKAction.sequence([waitAnimation,SwitchScene])
                    run(PressedbuttoN)
                    borderRect.run(SKAction.scaleX(to: 0.8, duration: 0.5))
                    borderRect.run(SKAction.scaleY(to: 0.8, duration: 0.5))
                    playbutton.run(SKAction.scaleX(to: 0.93, duration: 0.43))
                    playbutton.run(SKAction.scaleY(to: 0.93, duration: 0.43))
                    //playbutton.run(SKAction.scaleY(to: 0.66, duration: 0.5))
                }else if node.name == "sound_image"{
                    pressedButton(button: soundImage, time: 0.2, scale: 0.04)
                    disableUserInter(time: 1)
                    if defaults.bool(forKey: "soundon") == true {
                        defaults.set(false, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound off")
                    }else if defaults.bool(forKey: "soundon") == false {
                        defaults.set(true, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound on")
                        }
                }else if node.name == "music_image"{
                    pressedButton(button: musicImage, time: 0.2, scale: 0.04)
                    disableUserInter(time: 1)
                    
                    if defaults.bool(forKey: "MusicOn?") == false {
                        defaults.set(true, forKey: "MusicOn?")
                        musicImage.texture = SKTexture(imageNamed: "musicon")
                        if defaults.bool(forKey: "MUSICEVERLAUNCHED") == true {
                            if MUSIClaunched == true {
                            MusicPlayer.play()
                            }else{
                                BackgroundMusic()
                            }
                        }else if defaults.bool(forKey: "MUSICEVERLAUNCHEE") == false{
                            BackgroundMusic()
                        }
                        
                    }else if defaults.bool(forKey: "MusicOn?") == true {
                        defaults.set(false, forKey: "MusicOn?")
                        MusicPlayer.pause()
                        musicImage.texture = SKTexture(imageNamed: "musicoff")
                    }
                }else if node.name == "skinshop_image"{
                    pressedButton(button: SkinShop, time: 0.2, scale: 0.08)
                    disableUserInter(time: 1)
                    SkinShopFunc()
                }
            }
        }
    }
}

