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
                print("queue")
            }
        }
        MUSIClaunched = true
    }
    
    func spawncoins() {
        let CoinSound = SKAction.playSoundFileNamed("gamecoin.wav", waitForCompletion: false)
        if defaults.bool(forKey: "soundon") == true{
            run(SKAction.sequence([CoinSound]))
        }
        let vector = SKAction.move(to: CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9)), duration: 0.85)
        let fadeout = SKAction.fadeOut(withDuration: 0.15)
        let Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.zPosition = 40
        let wait = SKAction.wait(forDuration: 0.09)
        let Animation = SKAction.sequence([
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS2")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS3")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS4")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS5")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS6")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS7")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS8")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS9")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS10")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS1")})])
        let loop = SKAction.sequence([Animation])
        let final = SKAction.repeatForever(loop)
        addChild(Coins)

        Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.0001))
        Coins.position = CGPoint(x: 0.8*(self.frame.maxX/4), y: 0.3*(self.frame.maxY/9))
        Coins.run(final)
        Coins.run(SKAction.sequence([SKAction.wait(forDuration: 0.7),fadeout]))
        Coins.run(vector)
        
    }
    
    
    func LastGameVictory(){
        let ApparitionRect = SKShapeNode(rectOf: CGSize(width: 105, height: 32.5), cornerRadius: 10)
        ApparitionRect.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        ApparitionRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        ApparitionRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        ApparitionRect.zPosition = 2
        ApparitionRect.lineWidth = CGFloat(2.5)

        ApparitionRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))

        
        let AppearCoinsRect = SKShapeNode(rectOf: CGSize(width: 85, height: 40), cornerRadius: 10)
        AppearCoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        AppearCoinsRect.fillColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.strokeColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.lineWidth = CGFloat(5)
        AppearCoinsRect.zPosition = 2
        addChild(AppearCoinsRect)
        addChild(ApparitionRect)
        
        
        AppearCoinsRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))
        
        run(SKAction.sequence([SKAction.run{self.spawncoins()},SKAction.wait(forDuration: 0.6),SKAction.run{self.spawncoins()}]))
 
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
    
        let lvluptext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvluptext.position = CGPoint(x:1.9*(frame.maxX/3), y: (3.5 * (frame.maxY/5)))
        lvluptext.fontSize = 20
        lvluptext.text = "LEVEL UP!"
        lvluptext.zPosition = 4
        lvluptext.run(SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 1.75))
        lvluptext.run(SKAction.fadeOut(withDuration: 1.75))
        
        print("lvl up")
        let lvluprect = SKShapeNode(rectOf: CGSize(width: 110, height: 35), cornerRadius: 10)
        lvluprect.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        lvluprect.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        lvluprect.position = CGPoint(x:frame.midX, y: (3.95 * (frame.maxY/5)))
        lvluprect.zPosition = 3
        lvluprect.run(SKAction.fadeOut(withDuration: 1.75))
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
    var coinsInt : Int!
  
    

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

 
   
    class AddSkinSlot {
        let defo = UserDefaults.standard

        var positionn : CGPoint!
        var SkinTexture : SKTexture!
        var SlotUnlocked : Bool!
        var checkbox : SKSpriteNode!
        var LockState : Bool!
        var OuterRectangle = SKShapeNode(rectOf: CGSize(width: 72, height: 80), cornerRadius: 10)
        
        var SlotNumberValue : Int!
        var PriceBanner : SKShapeNode!
        var PriceText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        var CoinsImage : SKSpriteNode!

        var SkinSelec : SKSpriteNode!
        
        var CheckedBool : Bool!
        //ar checkbox : SKSpriteNode!

        
        init(Position : CGPoint, SkinTexture : SKTexture, LockedState : Bool, SlotNumber : Int, CheckedState : Bool){
            OuterRectangle.zPosition = 30
            OuterRectangle.lineWidth = CGFloat(3)
            positionn = Position
            OuterRectangle.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
            OuterRectangle.position = CGPoint(x: Position.x, y: Position.y + 60)
            SlotNumberValue = SlotNumber
            LockState = LockedState
            CheckedBool = CheckedState
            SkinSelec = SKSpriteNode(imageNamed: "back")
            SkinSelec.position = CGPoint(x: Position.x, y: Position.y + 60)

            SkinSelec.zPosition = 30
            SkinSelec.xScale = 0.22
            SkinSelec.yScale = 0.22
    
            
            if SlotNumber == 2 {
                SkinSelec.texture = SKTexture(imageNamed: "backgreen")
            }else if SlotNumber == 3 {
                SkinSelec.texture = SKTexture(imageNamed: "backred")
            }else if SlotNumber == 4 {
                SkinSelec.texture = SKTexture(imageNamed: "backblue")
            }else if SlotNumber == 5 {
                SkinSelec.texture = SKTexture(imageNamed: "backorange")
            }else if SlotNumber == 6 {
                SkinSelec.texture = SKTexture(imageNamed: "backgrey")
            }else if SlotNumber == 7 {
                SkinSelec.texture = SKTexture(imageNamed: "backchristmas")
            }else if SlotNumber == 8 {
                SkinSelec.texture = SKTexture(imageNamed: "backhalloween")
            }else if SlotNumber == 9 {
                SkinSelec.texture = SKTexture(imageNamed: "backblack")
            }
            
            
            if LockState == true{
                checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "locked"))
                PriceBanner = SKShapeNode(rectOf: CGSize(width: 72, height: 27), cornerRadius: 0)
                PriceBanner.fillColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
                PriceBanner.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)

                CoinsImage = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
                CoinsImage.xScale = 0.3
                CoinsImage.yScale = 0.3
                PriceText.text = "50"
                PriceText.fontSize = 17
            
                PriceBanner.position = CGPoint(x: Position.x, y: Position.y + 60)
                CoinsImage.position = CGPoint(x: Position.x + 13, y: Position.y + 62)
                PriceText.position = CGPoint(x: Position.x - 13, y: Position.y + 55)
                
                CoinsImage.zPosition = 41
                PriceBanner.zPosition = 39
                PriceText.zPosition = 40
                PriceText.name = "locknode"
                CoinsImage.name = "locknode"
                PriceBanner.name = "locknode"

            }else if LockState == false{
                let bruh = String(SlotNumber)
                let str = "Slot\(bruh)"
                PriceBanner = SKShapeNode()
                CoinsImage = SKSpriteNode()
                
                if defo.string(forKey: "SlotChecked") == str {
                    checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "checked"))
                }else {
                    checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "unchecked"))

                }
        
                
            }
            checkbox.xScale = 0.2
            checkbox.yScale = 0.2
            checkbox.alpha = 1
            OuterRectangle.alpha = 1
            checkbox.zPosition = 16
            checkbox.run(SKAction.fadeIn(withDuration: 0.3))
            OuterRectangle.run(SKAction.fadeIn(withDuration: 0.3))
            print("PEDALE")
            checkbox.position = positionn
            OuterRectangle.name = "shopnode"
            SkinSelec.name = "shopnode"
            checkbox.name = "shopnode"
        }
        

    }
    var lvltext : SKLabelNode!
    var lvlrect : SKShapeNode!
    var CoinsAdaptivePos : CGPoint!
    
    var slot9 : AddSkinSlot!
    var slot8 : AddSkinSlot!
    var slot7 : AddSkinSlot!
    var slot6 : AddSkinSlot!
    var slot5 : AddSkinSlot!
    var slot4 : AddSkinSlot!
    var slot3 : AddSkinSlot!
    var slot2 : AddSkinSlot!
    var slot1 : AddSkinSlot!
    
    var skinshoptxt : SKLabelNode!
    var skinshoprect : SKShapeNode!
    
    let gouttesound = SKAction.playSoundFileNamed("goutte.wav", waitForCompletion: true)


    func SkinShopFunc(){
        SkinShopTouched = true
        mainrect = SKShapeNode(rectOf: CGSize(width: 4.5*(frame.maxX/5), height: 3.4*(frame.maxY/5)), cornerRadius: 10)
        mainrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        mainrect.zPosition = 15
        mainrect.name = "shopnode"
        mainrect.alpha = CGFloat(0)
        mainrect.lineWidth = CGFloat(3)
        mainrect.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(mainrect)
        mainrect.run(SKAction.fadeIn(withDuration: 0.3))
        
        skinshoprect = SKShapeNode(rectOf: CGSize(width: 4.25*(frame.maxX/5), height: 1*(frame.maxY/12)), cornerRadius: 10)
        skinshoprect.position = CGPoint(x: frame.minX - 50, y: 8*(frame.maxY/9))
        skinshoprect.zPosition = 14
        skinshoprect.fillColor = UIColor(red: 19/255, green: 28/255, blue: 47/255, alpha: 1)
        skinshoprect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        skinshoprect.lineWidth = CGFloat(2.5)
        skinshoprect.alpha = 0


        skinshoptxt = SKLabelNode(fontNamed: "TextaW00-Heavy")
        skinshoptxt.zPosition = 15
        skinshoptxt.text = "SKIN SHOP"
        skinshoptxt.fontSize = 30
        skinshoptxt.position = CGPoint(x: frame.minX - 50, y: 7.93*(frame.maxY/9))
        skinshoptxt.alpha = 0

        
        skinshoprect.name = "shopnode"
        skinshoptxt.name = "shopnode"

        skinshoptxt.run(SKAction.fadeIn(withDuration: 0.35))
        skinshoprect.run(SKAction.fadeIn(withDuration: 0.35))

        skinshoprect.run(SKAction.move(to: CGPoint(x: frame.midX, y: 8*(frame.maxY/9)), duration: 0.4))
        skinshoptxt.run(SKAction.move(to: CGPoint(x: frame.midX, y: 7.85*(frame.maxY/9)), duration: 0.4))
        addChild(skinshoprect)
        addChild(skinshoptxt)

        
        slot9 = AddSkinSlot.init(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot9LockState"), SlotNumber: 9,CheckedState: defaults.bool(forKey: "Slot9Checked"))
        slot8 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot8LockState"), SlotNumber: 8,CheckedState: defaults.bool(forKey: "Slot8Checked"))
        slot7 = AddSkinSlot.init(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot7LockState"), SlotNumber: 7,CheckedState: defaults.bool(forKey: "Slot7Checked"))
        
        slot6 = AddSkinSlot.init(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot6LockState"), SlotNumber: 6,CheckedState: defaults.bool(forKey: "Slot6Checked"))
        slot5 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot5LockState"), SlotNumber: 5,CheckedState: defaults.bool(forKey: "Slot5Checked"))
        slot4 = AddSkinSlot.init(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot4LockState"), SlotNumber: 4,CheckedState: defaults.bool(forKey: "Slot4Checked"))

        slot1 = AddSkinSlot.init(Position: CGPoint(x: 1.5*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot1LockState"), SlotNumber: 1,CheckedState: defaults.bool(forKey: "Slot1Checked"))
        slot2 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot2LockState"), SlotNumber: 2,CheckedState: defaults.bool(forKey: "Slot2Checked"))
        slot3 = AddSkinSlot.init(Position: CGPoint(x: 4.5*(frame.maxX/6), y: 4*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot3LockState"), SlotNumber: 3,CheckedState: defaults.bool(forKey: "Slot3Checked"))
   
 

        addChild(slot9!.OuterRectangle); addChild(slot8!.OuterRectangle); addChild(slot7!.OuterRectangle); addChild(slot6!.OuterRectangle); addChild(slot5!.OuterRectangle); addChild(slot4!.OuterRectangle); addChild(slot3!.OuterRectangle); addChild(slot2!.OuterRectangle); addChild(slot1!.OuterRectangle)
        
        addChild(slot9!.CoinsImage); addChild(slot8!.CoinsImage); addChild(slot7!.CoinsImage); addChild(slot6!.CoinsImage); addChild(slot5!.CoinsImage); addChild(slot4!.CoinsImage); addChild(slot3!.CoinsImage); addChild(slot2!.CoinsImage); addChild(slot1!.CoinsImage)
        
        addChild(slot9!.SkinSelec); addChild(slot8!.SkinSelec); addChild(slot7!.SkinSelec); addChild(slot6!.SkinSelec); addChild(slot5!.SkinSelec); addChild(slot4!.SkinSelec); addChild(slot3!.SkinSelec); addChild(slot2!.SkinSelec); addChild(slot1!.SkinSelec)
        
   
        
        addChild(slot9!.checkbox); addChild(slot8!.checkbox); addChild(slot7!.checkbox); addChild(slot6!.checkbox); addChild(slot5!.checkbox); addChild(slot4!.checkbox); addChild(slot3!.checkbox); addChild(slot2!.checkbox); addChild(slot1!.checkbox)
        
        addChild(slot9!.PriceText); addChild(slot8!.PriceText); addChild(slot7!.PriceText); addChild(slot6!.PriceText); addChild(slot5!.PriceText); addChild(slot4!.PriceText); addChild(slot3!.PriceText); addChild(slot2!.PriceText); addChild(slot1!.PriceText)
        
        addChild(slot9!.PriceBanner); addChild(slot8!.PriceBanner); addChild(slot7!.PriceBanner) ;addChild(slot6!.PriceBanner) ;addChild(slot5!.PriceBanner) ;addChild(slot4!.PriceBanner) ;addChild(slot3!.PriceBanner) ;addChild(slot2!.PriceBanner) ;addChild(slot1!.PriceBanner)
    }
    
    

    func Unlock(Slot : AddSkinSlot){
        let previousCoinValue = defaults.integer(forKey: "UserCoins")
        Slot.PriceText.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.CoinsImage.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.PriceBanner.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.checkbox.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.checkbox.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.run{Slot.checkbox.texture = SKTexture(imageNamed: "unchecked")}, SKAction.fadeIn(withDuration: 0.3)]))
        defaults.set(previousCoinValue - 50, forKey: "UserCoins")
        coinsInt = defaults.integer(forKey: "UserCoins")
        CoinsText.text = "\(coinsInt!)"
        let a = String(Slot.SlotNumberValue)
        let stringg = "Slot\(a)LockState"
        print(stringg)
        defaults.set(false, forKey: stringg)
        
    }
    
    func CheckIn(Slot : AddSkinSlot){
        let slotarray = [slot1,slot2,slot3,slot4,slot5,slot6,slot7,slot8,slot9]
        let str1 = defaults.string(forKey: "SlotChecked")
        for (_, element) in slotarray.enumerated(){
            if "Slot\(String(element!.SlotNumberValue))" == str1 {
                let slot = element!
                slot.checkbox.texture = SKTexture(imageNamed: "unchecked")
            }
        }
        Slot.checkbox.texture = SKTexture(imageNamed: "checked")
        let a = String(Slot.SlotNumberValue)
        let stringg = "Slot\(a)"
        let FadeRect = SKShapeNode(rectOf: CGSize(width: 79.2, height: 88), cornerRadius: 12.5)
        let daPoint = Slot.OuterRectangle.position
        FadeRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
        FadeRect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        FadeRect.position = daPoint
        FadeRect.zPosition = 100
        FadeRect.lineWidth = CGFloat(2.5)
        addChild(FadeRect)
        FadeRect.run(SKAction.sequence([SKAction.wait(forDuration: 0.35),SKAction.fadeOut(withDuration: 0.15)]))
        FadeRect.run(SKAction.scaleX(to: 1.3, duration: 1))
        FadeRect.run(SKAction.scaleY(to: 1.1, duration: 0.58))

        defaults.set(stringg, forKey: "SlotChecked")
        
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
        
        lvltext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvltext.position = CGPoint(x:frame.midX, y: (3.9 * (frame.maxY/5)))
        lvltext.fontSize = 20
        lvltext.text = "LEVEL \(defaults.integer(forKey: "UserLvl"))"
        lvltext.zPosition = 4
        
        lvlrect = SKShapeNode(rectOf: CGSize(width: 100, height: 30), cornerRadius: 10)
        lvlrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.position = CGPoint(x:frame.midX, y: (3.95 * (frame.maxY/5)))
        lvlrect.zPosition = 3

        
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
        
        
            
        coinsInt = defaults.integer(forKey: "UserCoins")
        CoinsText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
        CoinsText.text = "\(coinsInt!)"
        CoinsText.fontSize = 20
        CoinsText.zPosition = 5
        CoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
        CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.zPosition = 4
        Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        Coins.zPosition = 20
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.01))
        if defaults.integer(forKey: "UserCoins") < 1000 {
            CoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
            CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
            CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            Coins.position = CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9))
            CoinsRect.zPosition = 4

        }
        
        if defaults.integer(forKey: "UserCoins") >= 1000 {
            CoinsRect = SKShapeNode(rectOf: CGSize(width: 105, height: 35), cornerRadius: 10)
            CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
            CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            Coins.position = CGPoint(x: 1*(frame.maxX/4), y: 0.91*(frame.maxY/9))
            CoinsRect.zPosition = 4

        }
     

        addChild(Coins)
        addChild(CoinsText)
        addChild(CoinsRect)
        addChild(lvlrect)
        
        
        func MenuCards(){
            var randInt = Int.random(in: 2...14)
            let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
            let randFamily = Int.random(in: 0...3)
            let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")
            let upperCard = SKSpriteNode(imageNamed: "back")
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
                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.4*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.05*(frame.maxY/20))
                SideButtons(Scaling: 0.18)
            }else if (frame.maxY) > CGFloat(736) && (frame.maxY) < CGFloat(900){////////////////// IPHONE XR 11 12 13
                AdaptiveValue = CGFloat(0.55)
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.83*(frame.maxY/9))

                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
                SideButtons(Scaling: 0.2)
            }else if (frame.maxY) > CGFloat(900){///////////// IPHONE MAX 13 MAX 12 MAX
                AdaptiveValue = CGFloat(0.585)
                musicImage.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.845*(frame.maxY/9))

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
                    swapCardSide(node: bottomCard, texture: SKTexture(imageNamed: "back"))
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
        
        let text = CoinsAdaptivePos
        let rect = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        var coin : CGPoint!
        if defaults.integer(forKey: "UserCoins") < 1000 {
             coin = CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        }else if defaults.integer(forKey: "UserCoins") >= 1000 {
             coin = CGPoint(x: 1*(frame.maxX/4), y: 0.91*(frame.maxY/9))

        }
        let moveAction1 = SKAction.move(to: text!, duration: 0.75)
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
                    if slot1!.OuterRectangle.contains(location){
                        print("e ouai")
                        if slot1!.LockState == false{
                            if "Slot1" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot1!)
                                defaults.set("back", forKey: "SkinSelected")
                                defaults.set("deck", forKey: "DeckSelected")
                            }
                        }
                    }else if slot2!.OuterRectangle.contains(location){
                        if slot2!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot2!)
                            }
                        }else if slot2!.LockState == false{
                            if "Slot2" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot2!)
                                defaults.set("backgreen", forKey: "SkinSelected")
                                defaults.set("deckgreen", forKey: "DeckSelected")
                            }
                        }
                    }else if slot3!.OuterRectangle.contains(location){
                        if slot3!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot3!)
                            }
                        }else if slot3!.LockState == false{
                            if "Slot3" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot3!)
                                defaults.set("backred", forKey: "SkinSelected")
                                defaults.set("deckred", forKey: "DeckSelected")
                            }
                        }
                    }else if slot4!.OuterRectangle.contains(location){
                        if slot4!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot4!)
                            }
                        }else if slot4!.LockState == false{
                            if "Slot4" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot4!)
                                defaults.set("backblue", forKey: "SkinSelected")
                                defaults.set("deckblue", forKey: "DeckSelected")
                            }
                        }
                    }else if slot5!.OuterRectangle.contains(location){
                        if slot5!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot5!)
                            }
                        }else if slot5!.LockState == false{
                            if "Slot5" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot5!)
                                defaults.set("backorange", forKey: "SkinSelected")
                                defaults.set("deckorange", forKey: "DeckSelected")
                            }
                        }
                    }else if slot6!.OuterRectangle.contains(location){
                        if slot6!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot6!)
                            }
                        }else if slot6!.LockState == false{
                            if "Slot6" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot6!)
                                defaults.set("backgrey", forKey: "SkinSelected")
                                defaults.set("deckgrey", forKey: "DeckSelected")
                            }
                        }
                    }else if slot7!.OuterRectangle.contains(location){
                        if slot7!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot7!)
                            }
                        }else if slot7!.LockState == false{
                            if "Slot7" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot7!)
                                defaults.set("backchristmas", forKey: "SkinSelected")
                                defaults.set("deckchristmas", forKey: "DeckSelected")
                            }
                        }
                    }else if slot8!.OuterRectangle.contains(location){
                        if slot8!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot8!)
                            }
                        }else if slot8!.LockState == false{
                            if "Slot8" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot8!)
                                defaults.set("backhalloween", forKey: "SkinSelected")
                                defaults.set("deckhalloween", forKey: "DeckSelected")
                            }
                        }
                    }else if slot9!.OuterRectangle.contains(location){
                        if slot9!.LockState == true {
                            if defaults.integer(forKey: "UserCoins") >= 50 {
                                Unlock(Slot: slot9!)
                            }
                        }else if slot9!.LockState == false{
                            if "Slot9" != defaults.string(forKey: "SlotChecked"){
                                CheckIn(Slot: slot9!)
                                defaults.set("backblack", forKey: "SkinSelected")
                                defaults.set("deckblack", forKey: "DeckSelected")
                            }
                        }
                    }
                    
                }else{//////////////////////////// SORT DU SHOP
                    for child in self.children {
                        if child.name == "shopnode"{
                            child.run(SKAction.fadeOut(withDuration: 0.2))
                            child.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run{child.removeFromParent()}]))
                        }else if child.name == "locknode"{
                            child.run(SKAction.fadeOut(withDuration: 0.2))
                            child.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run{child.removeFromParent()}]))
                        }
                    }
                }
            }
            for node in touchedNode {
                if node.name == "playrectangle"{
                    if defaults.bool(forKey: "soundon") == true{
                        run(gouttesound)
                    }
                    let waitAnimation = SKAction.wait(forDuration: 0.35)
                    let SwitchScene = SKAction.run{(self.startgame())}
                    let PressedbuttoN = SKAction.sequence([waitAnimation,SwitchScene])
                    run(PressedbuttoN)
                    borderRect.run(SKAction.scaleX(to: 0.8, duration: 0.5))
                    borderRect.run(SKAction.scaleY(to: 0.8, duration: 0.5))
                    playbutton.run(SKAction.scaleX(to: 0.93, duration: 0.43))
                    playbutton.run(SKAction.scaleY(to: 0.93, duration: 0.43))
                    
                }else if node.name == "sound_image"{
                    if defaults.bool(forKey: "soundon") == true{
                        run(gouttesound)
                    }
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
                    if defaults.bool(forKey: "soundon") == true{
                        run(gouttesound)
                    }
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
                    if defaults.bool(forKey: "soundon") == true{
                        run(gouttesound)
                    }
                    pressedButton(button: SkinShop, time: 0.2, scale: 0.08)
                    disableUserInter(time: 1)
                    SkinShopFunc()
                }
            }
        }
    }
}

