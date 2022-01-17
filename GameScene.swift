//
//  GameScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import SpriteKit
import GameplayKit
import UIKit


class GameScene: SKScene {
    
    var noas : Bool!
    override func didMove(to view: SKView) {
        defo.set(false, forKey: "FirstLaunch")
        disableUserInter(time: 1.5)
        let layout = SKAction.run({self.layoutScene()})
        let game = SKAction.run({self.gameSetup();self.displaycards()})
        let wait = SKAction.wait(forDuration: 0.2)
        run(SKAction.sequence([layout,wait,game]))
        AdaptiveNodes()
        print("gAMESECENE lasvictory : \(defo.bool(forKey: "LastGameVictory?"))")


        
    }
    func ModifyPlayerData(Exp : Int, CoinsWon : Int ){
        let PreviousCoin = defo.integer(forKey: "UserCoins")
        defo.set(PreviousCoin+CoinsWon, forKey: "UserCoins")
        
        let PreviousExp = defo.integer(forKey: "UserExp")
        
        if Exp > 0 {
            defo.set(PreviousExp + Exp, forKey: "UserExp")
        }else if Exp < 0 {
            if PreviousExp > 0 {
                if PreviousExp >= Exp {
                    defo.set(PreviousExp + Exp, forKey: "UserExp")
                }else if PreviousExp < Exp {
                    defo.set(PreviousExp - PreviousExp, forKey: "UserExp")
                }
            }else if PreviousExp < 0 {
                print("NAN CHEH")
            }
        }
        
    }
    
    func updateDealerScore() -> Int{
        
        if dealerHasAs == 1 {////////////////// LE DEALER A 21
            if dealerScore == 10 {/////// ! ! ! ! ! ! ! ! ! ! ! ! !
                dealerScore = 21
                dealerScoreLabel.text = "\(dealerScore)"
                lost(way: "DealerBetterScore")
                return(0)
            }
        }
        
        if dealerHasAs == 0 { ///////////////// LE DEALER N'AS PAS D'AS
            dealerScoreLabel.text = "\(dealerScore)"
            return(0)

        }
        
        
        
        if dealerHasAs >= 1 {///////// LE DEALER A UN AS OU PLUS
            if dealerEncounteredAs == dealerHasAs {
                dealerScoreLabel.text = "\(dealerScore)"
                return(0)
            }else{
                if dealerHasAs + dealerScore + 10 < 21 {//////////// 11 FAIT PAS BUST
                    dealerScoreLabel.text = "\(dealerScore + 11)"
                    dealerScore += 11
                }else if (dealerHasAs == 1) && (dealerScore == 10) {
                    dealerScore = 21
                    dealerScoreLabel.text = "\(dealerScore)"
                    lost(way: "DealerBetterScore")
                }else if (dealerHasAs + dealerScore + 10) > 21{///////////// LE 11 AS L'AURAIT FAIT BUST
                    dealerScore += 1
                    dealerScoreLabel.text = "\(dealerScore)"
                }
            }
            dealerEncounteredAs += 1
        }
        return(0)

    }
    func checkwin(){
        if dealerScore > 21 {
            won(alt: "DealerBust")
            DealerBusted = true
        }
        if dealerScore <= 21{
          if dealerScore < playerScore {
                won(alt: "VICTORY")
                
            }
            }
        if dealerScore == playerScore {
            push()
        }
        if DealerBusted == false {
            if dealerScore > playerScore+playerHasAs {
                lost(way: "DealerBetterScore")
            }
        }
        if dealerScore == 21 {
            if dealerScore > playerScore {
                lost(way: "DealerBetterScore")

            }
        }
        
    }

    func updatePlayerScoreStayPressed(){
        if playerHasAs > 0 {
            if playerHasOut10 == false { ////////////// STAY APPUYÉ :   SI LE SCORE DU  JOUEUR N'A PAS DEPASSSÉ 10 :     4,14 === > 14
                playerScore += playerHasAs+10
                playerScoreLabel.text = "\(playerScore)"
                }
            }
        if playerHasAs >= 1 {
            if playerScore + playerHasAs + 10 > 21 {
                playerScore = playerScore + playerHasAs
            }else if playerScore + playerHasAs + 10 < 21 {
                playerScore = playerScore + playerHasAs + 10
            }
        }
        
    }

    func updatePlayerScore(){
        
        if playerScore + playerHasAs > 21 {//////////////////// LE JOUEUR BUST
            lost(way: "Bust")
            PlayerBusted = true
        }
        
        if playerHasAs >= 1 {
                if playerScore >= 10 {//////////////////////// A UN AS OU + MAIS A DEPASSÉ 10
                    playerHasOut10 = true
                    playerScoreLabel.text = "\(playerScore+playerHasAs)"
                }else if playerHas10onStart == 0 {////////////////////// LE JOUEUR A UN AS ET A 10 DE SCORE
                    if playerScore == 10 {
                        playerScore = playerScore + playerHasAs
                        playerScoreLabel.text = "\(playerScore+playerHasAs)"
                    }else if playerScore < 10 {//////////////////// A EN DESSOUS DE 10 ET N'AS PAS STAY
                        playerScoreLabel.text = "\(playerHasAs+playerScore), \(10 + playerHasAs + playerScore)"
                    }
                }
        }
        if playerHasAs == 0 {//////////////////////// LE JOUEUR N'A AUCUN AS
            playerScoreLabel.text = "\(playerScore)"
        }
        
        if playerHasAs == 1 {//////////////////// 21 SANS BLACKJACK
            if playerScore == 10 {
                playerScore += 11
                playerScoreLabel.text = "\(playerScore)"
                let wait = SKAction.wait(forDuration: 0.7)/////////// JOUEUR TIRE 21
                isUserInteractionEnabled = false/////////////////////////////////////
                let stayy = SKAction.run {
                    (self.stay())
                }
                if playerHasAsonStart == false && playerHas10onStart == 0 {
                    run(SKAction.sequence([wait,stayy]))
                }
            }
        }
        if playerHas10onStart >= 1{////////////////////// BLACKJACK ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
                if playerHasAsonStart == true {
                    isUserInteractionEnabled = false

                    playerScoreLabel.text = "21"
                    won(alt:"BLACKJACK")

                }
            }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func DisplayEXPnumbers(EXP : Int) -> SKLabelNode{
        let fadeSequence = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 1),SKAction.fadeAlpha(to: 0, duration: 0.75)])
        var vector : CGVector!
        var OperatorString : String!
        let ExpText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        ExpText.position = CGPoint(x: 2.7*(frame.maxX/5), y: 1.77*(frame.maxY/4))
        ExpText.zPosition = 20
        if EXP > 0 {
            vector = CGVector(dx: 0, dy: 15)
            OperatorString = "+"
        }else if EXP < 0 {
            vector = CGVector(dx: 0, dy: -15)
            OperatorString = ""

        }else if EXP == 0 {
            vector = CGVector(dx: 15, dy: 0)
            OperatorString = "+"

        }
        let vectorSequence = SKAction.move(by: vector, duration: 1.5)
        addChild(ExpText)
        var exptext = String(EXP)
        var zbeub = OperatorString + exptext + "exp"
        ExpText.text =  "\(zbeub)"
        ExpText.fontSize = 18
        ExpText.run(fadeSequence)
        ExpText.run(vectorSequence)
        return(ExpText)
    }
    //var layout = SKAction.run()

    //let skView = view as SKView!
    var DealerBusted = false
    let playerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    //playerScoreLabel.text = "0"
    let dealerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    var playerScore = 0
    var dealerScore = 0
    
    let waitingtime =  SKAction.wait(forDuration: 10)

    var doubleass = 0
    
    var rect3 : SKShapeNode!
    var rect2 : SKShapeNode!
    var rect1 : SKShapeNode!

    
    var hitRect : SKShapeNode!
    var stayRect : SKShapeNode!

    var newNode : SKSpriteNode!
    
    var StayTouched = 0
    var hitPressed = 0
    
    var gameOver = false
    var vare = false
    
    var InnerRectangle : SKShapeNode!
    var OuterRectangle : SKShapeNode!
    var dealerEncounteredAs = 0
    var PlayercardSpawned = 0
    var DealercardSpawned = 0
    
    var justdepasse11 = false
    
    var playerScoreRect : SKShapeNode!
    var dealerScoreRect : SKShapeNode!
    
    var PlayerNewCardX : CGFloat!
    var PlayerNewCardY : CGFloat!
    
    var DealerNewCardX : CGFloat!
    var DealerNewCardY : CGFloat!
    
    var playerHasAs = 0
    var dealerHasAs = 0
    
    var PlayerBusted = false
    var defo = UserDefaults.standard

    var DealerReturnedCard : SKSpriteNode!
    var playerHasOut10 = false

    let CoinsNodes : SKSpriteNode! = nil
    var AlreadyWonLost = false
    var playerHas10onStart = 0
    var dealerHas10 = 0
    

    var deck : SKSpriteNode!
    var deckpos : CGPoint!
    
    var zCardPositions : CGFloat!
    var addedValue : CGFloat!
    var BLACKJACK = false
    var  playerHasAsonStart = false
    var playercard10 = false

    //let NewCardX : CGFloat!
    //let NewCardY : CGFloat!
    
    var background : SKSpriteNode!
    
    var dealercard1 : SKSpriteNode!
    
    var dealercard2 : SKSpriteNode!
    var dealercard3 : SKSpriteNode!
    
    var hitbutton : SKSpriteNode!
    var staybutton : SKSpriteNode!
    
    var playercard1 : SKSpriteNode!
    var playercard2 : SKSpriteNode!
    var playercard3 : SKSpriteNode!

    var AutomaticHIT = false
    
    func transition(){
        let comebackScene = MenuScene(size: view!.bounds.size)
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        comebackScene.scaleMode = .aspectFill
        view!.presentScene(comebackScene,transition: reveal)
    }
    func EndGameText(way:String){
        let remove = SKAction.run {
            self.removeFromParent()
        }
        for child in self.children {
            if child.name == "kards"{
                child.run(SKAction.sequence([SKAction.wait(forDuration: 1.2),SKAction.fadeOut(withDuration: 0.66),remove]))
            }
        }
        let effectsNode = SKEffectNode()
        let filter = CIFilter(name:"CIGaussianBlur",parameters: ["inputRadius": 10.0])
        effectsNode.filter = filter
        effectsNode.position = self.view!.center
        effectsNode.blendMode = .alpha
        shouldEnableEffects = true
        shouldRasterize = true
        
        
        let wait = SKAction.wait(forDuration: 2.5)
        let trans = SKAction.run({self.transition()})
        let text = SKLabelNode(fontNamed: "TextaW00-Heavy")
        text.fontSize = 33
        text.position = CGPoint(x: frame.maxX + 50, y: 3.35*(frame.maxY/4))
        text.zPosition = 10
        let InnerRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 50),cornerRadius: 5)
        InnerRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.42*(frame.maxY/4))
        InnerRectangle.strokeColor = UIColor(red: 80/255, green: 130/255, blue: 130/255, alpha: 0)
        InnerRectangle.alpha = 0.2
        InnerRectangle.zPosition = 10
        
        if way == "PlayerBust"{
            text.text = "YOU BUST"
            text.fontColor = UIColor.red
            EndGameScoreColorRect(User: "Player", Color: UIColor.white, WinState: true)
            DisplayEXPnumbers(EXP: -20)
            ModifyPlayerData(Exp: -20, CoinsWon: 0)
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)


        }else if way == "Victory" {
            text.text = "VICTORY"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.white, WinState: false)
            DisplayEXPnumbers(EXP: 25)
            ModifyPlayerData(Exp: 25, CoinsWon: 2)
            defo.set(true,forKey: "LastGameVictory?")
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)


        }else if way == "DealerWins" {
            text.text = "DEALER WINS"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Dealer", Color: UIColor.white, WinState: true)
            DisplayEXPnumbers(EXP: -20)
            ModifyPlayerData(Exp: -20, CoinsWon: 0)
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)


        }else if way == "Push"{
            text.text = "PUSH"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.white, WinState: false)
            EndGameScoreColorRect(User: "Dealer", Color: UIColor.white, WinState: false)
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
            DisplayEXPnumbers(EXP: 0)
            ModifyPlayerData(Exp: 0, CoinsWon: 0)

        }else if way == "blackjack"{
            text.text = "BLACKJACK"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.white, WinState: true)
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)
            DisplayEXPnumbers(EXP: 50)
            ModifyPlayerData(Exp: 50, CoinsWon: 5)
            
            defo.set(true,forKey: "LastGameVictory?")
        }else if way == "DealerBust"{
            text.text = "DEALERBUST"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.white, WinState: true)
            DisplayEXPnumbers(EXP: 35)
            ModifyPlayerData(Exp: 35, CoinsWon: 2)
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)
            defo.set(true,forKey: "LastGameVictory?")

        }
        let addText = SKAction.run {
            self.addChild(text)
            text.alpha = CGFloat(0.3)
            text.yScale = CGFloat(0.8)
            text.xScale = CGFloat(0.7)
        }
        let MoveIn = SKAction.run {
            text.run(SKAction.fadeAlpha(to: 1, duration: 0.33))
            text.run(SKAction.scaleX(to: 1, duration: 0.33))
            text.run(SKAction.scaleY(to: 1, duration: 0.33))
            text.run(SKAction.moveTo(x: self.frame.midX, duration: 0.8))
        }
        
        let waitvitefait = SKAction.wait(forDuration: 0.6)
        

        
        let OuterRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 50),cornerRadius: 5)
        OuterRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.42*(frame.maxY/4))
        OuterRectangle.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        OuterRectangle.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0)
        OuterRectangle.lineWidth = CGFloat(5.5)
        OuterRectangle.zPosition = 9
        
        let ScaleScene = SKAction.scaleX(to: 15, duration: 0.8)
        let meh = SKAction.fadeAlpha(to: 1, duration: 1.25)
        let InnerAction = SKAction.run{InnerRectangle.run(ScaleScene)
                                InnerRectangle.run(meh)}
        let OuterAction = SKAction.run{OuterRectangle.run(ScaleScene)}
        
        let bro = SKAction.wait(forDuration: 0.5)
        let rectSeq = SKAction.sequence([InnerAction,bro,OuterAction])
        
        addChild(InnerRectangle)
        addChild(OuterRectangle)
        
        let VectorAll = SKAction.run {
            self.run(SKAction.sequence([
                addText,
                MoveIn,
                rectSeq
            ]))
            self.deck.run(SKAction.moveTo(y: self.frame.maxY + 100, duration: 0.6))

        }
        run(SKAction.sequence([waitvitefait,VectorAll,wait,trans]))
        
        //let kards = childNode(withName: "")
    }
    
    func EndGameScoreColorRect(User : String,Color : UIColor, WinState : Bool){
        
        rect1 = SKShapeNode(rectOf: CGSize(width: 60, height: 35),cornerRadius: 10)
        rect1.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)
        rect1.lineWidth = CGFloat(2)
        rect1.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rect1.zPosition = CGFloat(1)

        rect2 = SKShapeNode(rectOf: CGSize(width: 60, height: 35),cornerRadius: 10)
        rect2.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)
        rect2.lineWidth = CGFloat(2)
        rect2.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rect2.zPosition = CGFloat(1)
        
        rect3 = SKShapeNode(rectOf: CGSize(width: 60, height: 35),cornerRadius: 10)
        rect3.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)
        rect3.lineWidth = CGFloat(2)
        rect3.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rect3.zPosition = CGFloat(1)
        
        addChild(rect1)
        addChild(rect2)
        addChild(rect3)
        
        rect1.run(SKAction.fadeOut(withDuration: 0.8))
        rect1.run(SKAction.scaleX(to: 1.3, duration: 1))
        rect1.run(SKAction.scaleY(to: 1.15, duration: 1))
        
        rect2.run(SKAction.fadeOut(withDuration: 0.65))
        rect2.run(SKAction.scaleX(to: 1.35, duration: 1))
        rect2.run(SKAction.scaleY(to: 1.2, duration: 1))
        
        rect3.run(SKAction.fadeOut(withDuration: 0.5))
        rect3.run(SKAction.scaleX(to: 1.4, duration: 1))
        rect3.run(SKAction.scaleY(to: 1.25, duration: 1))
        
        if User == "Dealer"{
            dealerScoreRect.strokeColor = Color
            rect1.position = CGPoint(x: frame.midX, y:2.88*(frame.maxY/4))
            rect2.position = CGPoint(x: frame.midX, y:2.88*(frame.maxY/4))
            rect3.position = CGPoint(x: frame.midX, y:2.88*(frame.maxY/4))

        }else if User == "Player"{
            playerScoreRect.strokeColor = Color
            rect2.position = CGPoint(x: frame.midX, y: frame.midY-10)
            rect1.position = CGPoint(x: frame.midX, y: frame.midY-10)
            rect3.position = CGPoint(x: frame.midX, y: frame.midY-10)

        }
        if WinState == true {
    
        }
    }

    
    func lost(way:String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        
        
        if way == "Bust"{
            EndGameText(way: "PlayerBust")

            
        }else if way == "DealerBetterScore"{
            EndGameText(way: "DealerWins")
   
        }
    }

    func push(){
        AlreadyWonLost = true
        EndGameText(way: "Push")
    }
    
    
     
    func won(alt : String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        hitbutton.isUserInteractionEnabled = false
        staybutton.isUserInteractionEnabled = false

        
        if alt == "DealerBust"{

            EndGameText(way: "DealerBust")

            
        }else if alt == "VICTORY"{

            EndGameText(way: "Victory")


        }else if alt == "BLACKJACK"{
            EndGameText(way: "blackjack")
        }
        
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
        
    func MakeCGcolor(RED : CGFloat, GREEN : CGFloat,BLUE : CGFloat) -> CGColor {
        return(CGColor(red: RED/255, green: GREEN/255, blue: BLUE/255, alpha: 1.0))
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
        
    }

    func layoutScene(){
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

        let a = MakeCGcolor(RED: 0, GREEN: 12, BLUE: 24)
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
   
        func TopRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX , height: frame.midY / 3),cornerRadius: 40)
            rect.position = CGPoint(x: frame.midX, y: frame.maxY)
            rect.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.99)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(8)
            rect.zPosition = 10
            addChild(rect)
            
        }
        func MidRect(){

            let rect1 = SKShapeNode(rectOf: CGSize(width: frame.maxX - 12, height: frame.midY + 61), cornerRadius: 10)
            rect1.position = CGPoint(x: frame.midX, y: frame.midY)
            //rect1.fillColor = UIColor(red: 15/255, green: 33/255, blue: 200/255, alpha: 1.0)
            rect1.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
            rect1.lineWidth = CGFloat(3.5)
            rect1.zPosition = -10

            let rect2 = SKShapeNode(rectOf: CGSize(width: frame.maxX - 13, height: frame.midY + 60), cornerRadius: 10)
            rect2.position = CGPoint(x: frame.midX, y: frame.midY)
            //rect2.fillColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
            rect2.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.1)
            rect2.lineWidth = CGFloat(3.5)
            rect2.zPosition = -9
            addChild(rect1)
            rect1.run(SKAction.fadeAlpha(to: 1, duration: 1))
            //addChild(rect2)
            //xrect2.run(SKAction.fadeAlpha(to: 1, duration: 1))
        }

        func BottomRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 25, height: 3.5 * (frame.maxY/10)),cornerRadius: 35)
            rect.position = CGPoint(x: frame.midX, y: frame.minY)
            rect.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 1)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(7.5)
            addChild(rect)
        }
        
        func deckq(){
            deck = SKSpriteNode(imageNamed: "blue deck")
            deck.position = CGPoint(x: frame.maxX - 40, y: frame.maxY + 40)
            deck.xScale = 0.23
            deck.yScale = 0.2
            deck.zPosition = -10
            addChild(deck)
            deck.run(SKAction.move(to: deckpos  , duration: 1))
        }
        func hitfunc(){
            hitbutton = SKSpriteNode(imageNamed: "HIT")
            hitbutton.position = CGPoint(x:frame.midX - 85, y: frame.maxY / 10)
            hitbutton.name = "ButtonHit"
            hitbutton.zPosition = 1
            hitbutton.xScale = 0.36
            hitbutton.yScale = 0.36
            addChild(hitbutton)
            
        }
        func stayfunc(){
            staybutton = SKSpriteNode(imageNamed: "STAND")
            staybutton.position = CGPoint(x:frame.midX + 85, y: frame.maxY / 10)
            staybutton.name = "ButtonStay"
            staybutton.zPosition = 1
            staybutton.xScale = 0.36
            staybutton.yScale = 0.36
            addChild(staybutton)
        }
        func bjbaneer(){
            let baneer = SKSpriteNode(imageNamed: "blackjack2to3")
            baneer.position = CGPoint(x: frame.midX, y: frame.midY+30)
            baneer.xScale = 0.25
            baneer.yScale = 0.25
            addChild(baneer)
        }
        MidRect()
        deckq()
        hitfunc()
        stayfunc()
        BottomRect()
        TopRect()
        background.zPosition = -100
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        addChild(background)
        
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func returnDealerCard(card: SKSpriteNode) -> SKSpriteNode{
      return card
    }
    
    func spawnRandomCard(user:String, xPos:CGFloat ,yPos:CGFloat) -> SKSpriteNode{
        
        addedValue = 1
        zCardPositions = zCardPositions + addedValue
        let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
        let randFamily = Int.random(in: 0...3)
        var randInt = Int.random(in: 2...14)///////////////////////////////////////////// RANDOMIZER
        let returnedCard = SKSpriteNode(imageNamed: "backk")
        let randomCardAction = SKAction.run({self.addChild(returnedCard)})
        let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")

        let wait = SKAction.wait(forDuration: 0.3)
                
        if randInt == 11 || randInt == 12 || randInt == 13{
            randInt = 10
        }
        if (user == "Dealer"){
            DealercardSpawned += 0
            run(SKAction.sequence([randomCardAction,wait]))
            if randInt != 14 {
                dealerScore += randInt

            }else if randInt == 14{
                dealerHasAs += 1
            }
            }
        
        else if user == "Player"{
            PlayercardSpawned += 1
            run(SKAction.sequence([randomCardAction,wait]))
            if randInt != 14 {
                playerScore+=randInt
            }else if randInt == 14{
                playerHasAs += 1
            }
            

            if playerHasAs == 11{
                playerScore += playerHasAs
            }

        }
        else if user == "Returned"{
            addChild(returnedCard)
        }

        if vare == true {
            if randInt != 14 {
                noas = false
            }else {
                noas = true
            }
        }
        returnedCard.xScale = 0.33
        returnedCard.yScale = 0.31
        returnedCard.zPosition = zCardPositions
        returnedCard.position = CGPoint(x: frame.maxX, y: frame.maxY)
        //let moveToPointX = SKAction.moveTo(x: xPos, duration: 0.5)
        //let moveToPointY = SKAction.moveTo(y: yPos, duration: 0.5)
        //let moveXandY = SKAction.sequence([moveToPointX,moveToPointY])
        let waitCardVector = SKAction.wait(forDuration: 0.55)
        let topleft = CGPoint(x: frame.maxX - 70, y: frame.maxY - 75)
        let CardPoint = CGPoint(x: xPos, y: yPos)
        let vector = CGVector(dx: CardPoint.x - topleft.x, dy: CardPoint.y - topleft.y)
        let vectorAction = SKAction.move(by: vector, duration: 0.4)
        let movementSound = SKAction.playSoundFileNamed("cardmoov.mp3", waitForCompletion: false)
        let flippingSound = SKAction.playSoundFileNamed("cardflip.mp3", waitForCompletion: false)
        let waitSound = SKAction.wait(forDuration: 0.59)

        let swapCardSide = SKAction.run {
            returnedCard.run(SKAction.scaleX(to: 0.28, duration: 0.1));///// REDUIT UN PEU LA CARTE
            returnedCard.texture = RandomCardTexture;
            returnedCard.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            returnedCard.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            returnedCard.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            returnedCard.run(SKAction.scaleX(to: 0.33, duration: 0.15))////////////// REMET A TAILLE NORMALE
            // ||
        }
        if (user != "StayDealer") && (user != "Returned") {
            run(SKAction.sequence([SKAction.run{returnedCard.run(vectorAction)},waitCardVector,swapCardSide]))
            if defo.bool(forKey: "soundon") == true{
                run(SKAction.sequence([movementSound,waitSound,flippingSound]))
            }
        }else if user == "Returned"{
            returnedCard.run(SKAction.sequence([vectorAction]))
            if defo.bool(forKey: "soundon") == true{
                run(SKAction.sequence([movementSound]))
            }
        }
        
        return(returnedCard)
    }
    
    
    
    func funcReturnDealer(card : SKSpriteNode, CardNumber : Int, FamilyNumber : Int) -> SKSpriteNode{
        let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
        let RandomCardTexture = SKTexture(imageNamed: "\(CardNumber) \(family[FamilyNumber])")
        let flippingSound = SKAction.playSoundFileNamed("cardflip.mp3", waitForCompletion: false)

        let swapCardSide = SKAction.run {
            card.run(SKAction.scaleX(to: 0.28, duration: 0.1));///// REDUIT UN PEU LA CARTE
            card.texture = RandomCardTexture;
            card.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            card.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            card.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            card.run(SKAction.scaleX(to: 0.33, duration: 0.15))

        }
        if defo.bool(forKey: "soundon") == true{
            run(SKAction.sequence([flippingSound]))
        }
        run(swapCardSide)
        return(card)
    }
    
    
    func AdaptiveNodes(){
        if (frame.maxY) <= CGFloat(580){///////////////// IPOD

            
        }else if (frame.maxY) > CGFloat(600) && (frame.maxY) < CGFloat(730){///////////////// IPHONE 7 8
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 8.3)))
        }else if (frame.maxY) > CGFloat(736) && (frame.maxY) < CGFloat(900){////////////////// IPHONE XR 11 12 13
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 9.5)))
        }else if (frame.maxY) > CGFloat(900){///////////// IPHONE MAX 13 MAX 12 MAX
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 9.5)))
        }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    
    
    func gameSetup(){

        DealerNewCardX = 70
        DealerNewCardY = 80
        zCardPositions = 0
        addedValue = 1
        
        func displayScores(){
                    playerScoreLabel.position = CGPoint (x : frame.midX, y: frame.midY-20)
                    playerScoreLabel.text = "0"
                    playerScoreLabel.fontSize = 23
            playerScoreLabel.zPosition = 21
                    playerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: frame.midY-30, width: 60, height: 35),cornerRadius: 10)
                    playerScoreRect.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
                    playerScoreRect.lineWidth = CGFloat(3)
                    playerScoreRect.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            playerScoreRect.zPosition = 20
                    addChild(playerScoreLabel)
                    addChild(playerScoreRect)
                    
                    dealerScoreLabel.position = CGPoint (x: frame.midX, y: 2 * (frame.maxY/2.8))
                    dealerScoreLabel.text = "0"
                    dealerScoreLabel.fontSize = 23
            dealerScoreLabel.zPosition = 21
            
                    dealerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: 2 * (frame.maxY/2.8) - 10, width: 60, height: 35),cornerRadius: 10)
                    dealerScoreRect.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
                    dealerScoreRect.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            dealerScoreRect.zPosition = 20
                    dealerScoreRect.lineWidth = CGFloat(3)
                    addChild(dealerScoreLabel)
                    addChild(dealerScoreRect)
                }
                
            displayScores()

                
 
            }
            func displaycards(){

                
                disableUserInter(time: 1.5)
                
                
                
                let waitCard = SKAction.wait(forDuration: 0.7)
                let updatePlayerAction = SKAction.run {
                    (self.updatePlayerScore())
                }
                let updateDealerAction = SKAction.run {
                    (self.updateDealerScore())
                }

             
                let playerAction1 = SKAction.run {
                    self.playercard1 = self.spawnRandomCard(user: "Player", xPos: -10, yPos: self.frame.maxY / 3.6 )
                    self.playercard1.name = "kards"
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                        if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }
                
                let dealerCard1Action = SKAction.run {
                    self.dealercard1 = self.spawnRandomCard(user: "Dealer", xPos: -10, yPos: 2 * (self.frame.maxY / 3.6) );
                    self.dealercard1.name = "kards"
                }
                
                let playerAction2 = SKAction.run {
                    self.playercard2 = self.spawnRandomCard(user: "Player", xPos: 30 , yPos: self.frame.maxY / 3.6 - 10);
                    self.playercard2.name = "kards"

                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                    if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }

                let dealerCard2Action = SKAction.run {
                    self.DealerReturnedCard = self.spawnRandomCard(user: "Returned", xPos: 30, yPos: 2 * (self.frame.maxY / 3.6) - 10);
                    self.DealerReturnedCard.name = "kards"

                }
                run(SKAction.sequence([playerAction1,waitCard,updatePlayerAction,
                                       dealerCard1Action,waitCard,updateDealerAction,
                                       playerAction2,waitCard,updatePlayerAction,
                                       dealerCard2Action]))

                updatePlayerScore()
                updateDealerScore()
                
                if playerScore == 10 {
                    playerHas10onStart += 1
                }
                if playerHasAs == 1 {
                    playerHasAsonStart = true
                }
                PlayerNewCardX = 70
                PlayerNewCardY = 20
                
                if playerHasAsonStart == true && playerHas10onStart == 1 {
                    BLACKJACK = true
                }
        
            }
    
            func hit(){
                disableUserInter(time: 1)
                let waitCard = SKAction.wait(forDuration: 0.7)
                let PlayerUpdate = SKAction.run{
                    self.updatePlayerScore()
                }
                playercard3 = spawnRandomCard(user : "Player", xPos: PlayerNewCardX, yPos: self.frame.maxY / 3.6 - PlayerNewCardY)
                playercard3.name = "kards"

                run(SKAction.sequence([waitCard,PlayerUpdate]))

                let waitCardSpawn = SKAction.wait(forDuration: 0.5)
                let disableInter: () = isUserInteractionEnabled = true
                let enableInter: () = isUserInteractionEnabled = true
                let disablePlayerInteraction = SKAction.sequence([
                    SKAction.run{disableInter},
                    SKAction.run{self.hitbutton.alpha = 0.3},
                    waitCardSpawn,
                    SKAction.run{enableInter},
                    SKAction.run{self.hitbutton.alpha = 1.0}
                
                ])
                run(SKAction.sequence([disablePlayerInteraction]))
                if playerScore+playerHasAs == 21 && playerHasAsonStart == false && playerHas10onStart == 0{////////////////////////////////////
                    let wait = SKAction.wait(forDuration: 0.7)/////////// JOUEUR TIRE 21
                    isUserInteractionEnabled = false/////////////////////////////////////
                    let stayy = SKAction.run {
                        if self.BLACKJACK == false {
                            (self.stay())
                        }
                    }
                    run(SKAction.sequence([wait,stayy]))
                }
                PlayerNewCardX += 40
                PlayerNewCardY += 10
                
            }
            
    
            func stay(){
                AutomaticHIT = true
                var stayX : CGFloat!
                var stayY : CGFloat!
                isUserInteractionEnabled = false
                stayX = 70
                stayY = 20
                updatePlayerScoreStayPressed()
                disableUserInter(time: 5)
                var randInt = Int.random(in: 2...14)/////////////////////////////////////////////////// RANDOMIZER
                let waitNextCard = SKAction.wait(forDuration: 0.7)
                var randFamily = Int.random(in: 0...3)
                

                
                let spawnReturnedCard = SKAction.run {
                   
                  _ = self.funcReturnDealer(card: self.DealerReturnedCard, CardNumber: randInt, FamilyNumber: randFamily)
                }
                let waitCardAnim = SKAction.wait(forDuration: 0.2)

                
                let returnUpdate = SKAction.run {
                    if randInt == 11 || randInt == 12 || randInt == 13{
                        randInt = 10
                        self.dealerScore += randInt
                    }else if randInt == 14 {
                        self.dealerHasAs += 1
                    }else{
                        self.dealerScore += randInt
                    }
                    self.updateDealerScore()
                }
                
                let dealerUpdate = SKAction.run {
                    self.updateDealerScore()
                }

                
                let checkwinn = SKAction.run {
                    self.checkwin()
                }
                
                let giveNewCard = SKAction.run {

                    if self.dealerScore < 17 {
                        self.dealercard3 = self.spawnRandomCard(user: "Dealer", xPos: stayX, yPos:  2 * (self.frame.maxY / 3.6) - stayY)
                        self.dealercard3.name = "kards"
                        stayX += 40
                        stayY += 10
                    }else{
                        self.gameOver = true
                        if self.AlreadyWonLost == false {
                            self.run(checkwinn)
                        }
                        self.removeAllActions()
                    }
                
                }
                let boucle = SKAction.run {
                    if self.gameOver == false {
                        self.run(SKAction.repeat(SKAction.sequence([giveNewCard,waitNextCard,dealerUpdate]),count: 20))
                    }
                    
                }
                //let repeatAction = SKAction.repeat(SKAction.sequence([giveNewCard,waitNextCard,dealerUpdate]),count: 20)
                run(SKAction.sequence([spawnReturnedCard,waitCardAnim,returnUpdate,waitNextCard,boucle]))
                
                print("Playerscore stayed : \(playerScore)")

            }
            
    
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
            {

                
                let wait = SKAction.wait(forDuration: 0.1)
                
                
                
                let ScaleDown = SKAction.scale(by: 0.85, duration: 0.11)
                let FadeDown = SKAction.fadeAlpha(to: 0.92, duration: 0.11)
                let ScaleBack = SKAction.scale(to: 0.35, duration: 0.11)
                let FadeBack = SKAction.fadeAlpha(to: 1, duration: 0.11)
                let Pressedbutton = SKAction.sequence([ScaleDown,FadeDown,ScaleBack,FadeBack])
                
                for touch in touches {
                    
                    let location = touch.location(in: self)
                    let touchedNode = self.nodes(at: location)
                    
                    for node in touchedNode {
                        
                        if node.name == "ButtonHit"{
                            node.run(Pressedbutton)
                            if StayTouched == 0 {
                                if playerScore < 21 {
                                    hit()
                                    hitPressed += 1
                                }
                            }
                        }
                        else if node.name == "ButtonStay"{
                            if PlayerBusted == false {
                            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            node.run(Pressedbutton)
                            if StayTouched < 1 || AutomaticHIT == false {
                                StayTouched += 1
                                stay()
                            }
                        }
                        }
                    }
                }
            }
        }
