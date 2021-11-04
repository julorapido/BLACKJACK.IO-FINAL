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
        //let waitInteraction = SKAction.wait(forDuration: 1)
        //isUserInteractionEnabled = false
        //let enableUserInteraction = SKAction.run {
        //    (self.isUserInteractionEnabled = true)
        //}
        //run(SKAction.sequence([waitInteraction,enableUserInteraction]))
        backgroundColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
        let layout = SKAction.run({self.layoutScene()})
        let game = SKAction.run({self.gameSetup();self.displaycards()})
        let wait = SKAction.wait(forDuration: 0.2)
        run(SKAction.sequence([layout,wait,game]))
        print(frame.maxY / 4)
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
            if dealerHasAs + dealerScore + 10 < 21 {//////////// 11 FAIT PAS BUST
                if dealerHasAs + dealerScore + 10 > playerScore + playerHasAs {
                    dealerScore += dealerHasAs + 10
                    dealerScoreLabel.text = "\(dealerScore)"
                    return(0)
                }else {
                    dealerScoreLabel.text = "\(dealerScore+dealerHasAs), \(dealerScore+10+dealerHasAs)"
                    return(0)
                }
            }else{///////////// LE 11 AS L'AURAIT FAIT BUST
                justdepasse11 = true
                if justdepasse11 == false {
                    dealerScore += dealerHasAs + 10
                    dealerScoreLabel.text = "\(dealerScore)"
                    return(0)
                }else if justdepasse11 == true {//////////// RAJOUTE DES AS EGALE À 1
                    if vare == false {
                    vare = true
                    dealerScore += dealerHasAs
                    dealerScoreLabel.text = "\(dealerScore)"
                    }else if vare == true {
                        if noas == true {
                            dealerScore += 1
                            dealerScoreLabel.text = "\(dealerScore)"
                            return(0)

                        }else if noas == false{
                            dealerScoreLabel.text = "\(dealerScore)"
                            return(0)
                        }
                    }
                }
            }
        }
        return(0)

    }
    func checkwin(){
        if dealerScore > 21 {
            won(alt: "DealerBust")
        }
        if dealerScore <= 21{
          if dealerScore < playerScore + playerHasAs{
                won(alt: "VICTORY")
                
            }
            }
        if dealerScore == playerScore+playerHasAs {
            push()
        }
        
        if dealerScore > playerScore+playerHasAs {
            lost(way: "DealerBetterScore")
        }
    }

    func updatePlayerScoreStayPressed(){
        if playerHasAs > 0 {
            if playerHasOut10 == false { ////////////// STAY APPUYÉ :   SI LE SCORE DU  JOUEUR N'A PAS DEPASSSÉ 10 :     4,14 === > 14
                playerScore += playerHasAs+10
                playerScoreLabel.text = "\(playerScore)"
                }
            }
        
        
        if playerHasAs == PlayercardSpawned  {
            playerScore = playerHasAs+10
            playerScoreLabel.text = "\(playerScore)"
        }
    }

    func updatePlayerScore(){
        
        if playerScore + playerHasAs > 21 {//////////////////// LE JOUEUR BUST
            lost(way: "Bust")
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

    //var layout = SKAction.run()

    //let skView = view as SKView!
    let playerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    //playerScoreLabel.text = "0"
    let dealerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    var playerScore = 0
    var dealerScore = 0
    
    let waitingtime =  SKAction.wait(forDuration: 10)

    var doubleass = 0
    
    var hitRect : SKShapeNode!
    var stayRect : SKShapeNode!

    var StayTouched = 0
    var hitPressed = 0
    
    var gameOver = false
    var vare = false
    
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
    
    
    var defo = UserDefaults.standard

    var DealerReturnedCard : SKSpriteNode!
    var playerHasOut10 = false

    var playerHas10onStart = 0
    var dealerHas10 = 0
    
    var zCardPositions : CGFloat!
    var addedValue : CGFloat!
    
    var  playerHasAsonStart = false
    var playercard10 = false

    
    //let NewCardX : CGFloat!
    //let NewCardY : CGFloat!
    
    var dealercard1 : SKSpriteNode!
    var dealercard2 : SKSpriteNode!
    var dealercard3 : SKSpriteNode!
    
    var hitbutton : SKSpriteNode!
    var staybutton : SKSpriteNode!
    
    var playercard1 : SKSpriteNode!
    var playercard2 : SKSpriteNode!
    var playercard3 : SKSpriteNode!

    func transition(){
        let comebackScene = MenuScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .right, duration: 0.5)
        comebackScene.scaleMode = .aspectFill
        view!.presentScene(comebackScene,transition: reveal)
    }
    
    func lost(way:String){
        isUserInteractionEnabled = false
        let previousExp = defo.integer(forKey: "UserExp")
        
        let wait = SKAction.wait(forDuration: 2)
        let trans = SKAction.run({self.transition()})
        if way == "Bust"{
            let playerBustRect = SKShapeNode(rectOf: CGSize(width: 120, height: 35),cornerRadius: 10)
            playerBustRect.fillColor = UIColor(red: 47/255, green: 69/255, blue: 83/255, alpha: 1.0)
            playerBustRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
            playerBustRect.position = CGPoint(x: frame.midX + 35, y: frame.midY - 45)
            let playerBust = SKLabelNode(fontNamed: "TextaW00-Heavy")
            playerBust.fontSize = 23
            playerBust.text = "BUST -20xp"
            playerBust.position = CGPoint(x: frame.midX + 35, y: frame.midY - 51)
            playerBust.fontColor = UIColor.red
            defo.set(previousExp - 20 , forKey: "UserExp")
            let playerBustAction = SKAction.run({
                self.addChild(playerBust)
                self.addChild(playerBustRect)
            })
            run(SKAction.sequence([playerBustAction,wait,trans]))
            
        }else if way == "DealerBetterScore"{
            let playerLost = SKLabelNode(fontNamed: "TextaW00-Heavy")
            playerLost.text = "DEALER WINS -25xp"
            playerLost.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            playerLost.fontColor = UIColor.red
            defo.set(previousExp - 25, forKey: "UserExp")
            let playerLostAction = SKAction.run({self.addChild(playerLost)})
            run(SKAction.sequence([playerLostAction,wait,trans]))
        }
    }

    func push(){
        let wait = SKAction.wait(forDuration: 2)
        let trans = SKAction.run({self.transition()})
        
        let push = SKLabelNode(fontNamed: "TextaW00-Heavy")
        push.text = "PUSH"
        push.position = CGPoint(x: frame.midX, y:frame.maxY-80)
        push.fontColor = UIColor.yellow
        
        let pushAction = SKAction.run({self.addChild(push)})
        run(SKAction.sequence([pushAction,wait,trans]))
    }
    func won(alt : String){
        isUserInteractionEnabled = false
        let previouswin = defo.integer(forKey: "UserExp")
        hitbutton.isUserInteractionEnabled = false
        staybutton.isUserInteractionEnabled = false
        let wait = SKAction.wait(forDuration: 2)
        let trans = SKAction.run({
            self.transition()})
        if alt == "DealerBust"{
            let WinDealerBustLabel = SKLabelNode(fontNamed:"TextaW00-Heavy")
            let WinningAction = SKAction.run({self.addChild(WinDealerBustLabel)})
            defo.set(40 + previouswin, forKey: "UserExp")
            WinDealerBustLabel.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            WinDealerBustLabel.text = "DEALERBUST +40xp"
            WinDealerBustLabel.fontColor = UIColor.orange
            run(SKAction.sequence([WinningAction,wait,trans]))

            
        }else if alt == "VICTORY"{
            let WinningRect = SKShapeNode(rectOf: CGSize(width: 120, height: 35),cornerRadius: 10)
            WinningRect.fillColor = UIColor(red: 47/255, green: 69/255, blue: 83/255, alpha: 1.0)
            WinningRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
            WinningRect.position = CGPoint(x: frame.midX + 35, y: frame.midY - 45)
            let WinningLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
            let WinninglabelAction = SKAction.run({
                self.addChild(WinningLabel)
                self.addChild(WinningRect)
            })
            defo.set(45 + previouswin, forKey: "UserExp")
            WinningLabel.fontSize = 23
            WinningLabel.position = CGPoint(x: frame.midX + 35, y: frame.midY - 45)
            WinningLabel.text = "PLAYER WINS +45xp"
            WinningLabel.fontColor = UIColor.green
            run(SKAction.sequence([WinninglabelAction,wait,trans]))

        }else if alt == "BLACKJACK"{
            let BlackjackLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
            let BlackjackLabelAction = SKAction.run({self.addChild(BlackjackLabel)})
            BlackjackLabel.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            defo.set(60 + previouswin, forKey: "UserExp")
            BlackjackLabel.text = "blackjack bro +60xp"
            BlackjackLabel.fontColor = UIColor.green
            run(SKAction.sequence([BlackjackLabelAction,wait,trans]))
        }
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func layoutScene(){
        func TopRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX , height: frame.midY / 3),cornerRadius: 40)
            rect.position = CGPoint(x: frame.midX, y: frame.maxY)
            rect.fillColor = UIColor(red: 1/255, green: 79/255, blue: 134/255, alpha: 1.0)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(10)
            rect.zPosition = 10
            addChild(rect)
            
        }
        func MidRect(){

            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 10, height: frame.midY + 60), cornerRadius: 10)
            rect.position = CGPoint(x: frame.midX, y: frame.midY)
            rect.fillColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
            rect.lineWidth = CGFloat(4.5)
            rect.zPosition = -10
            addChild(rect)

        }

        func BottomRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 25, height: frame.midY/1.5),cornerRadius: 35)
            rect.position = CGPoint(x: frame.midX, y: frame.minY)
            rect.fillColor = UIColor(red: 1/255, green: 79/255, blue: 134/255, alpha: 1.0)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(9)
            addChild(rect)
        }
        
        func deck(){
            let deck = SKSpriteNode(imageNamed: "HALLOWEEN DECK")
            deck.position = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 8.3)))
            deck.xScale = 0.5
            deck.yScale = 0.5
            deck.zPosition = -10
            addChild(deck)
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
        deck()
        bjbaneer()
        hitfunc()
        stayfunc()
        BottomRect()
        TopRect()
        
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
        print(family[1])
        var randFamily = Int.random(in: 0...3)
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
        returnedCard.xScale = 0.37
        returnedCard.yScale = 0.35
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
        let swapCardSide = SKAction.run {
            returnedCard.run(SKAction.scaleX(to: 0.32, duration: 0.1));///// REDUIT UN PEU LA CARTE
            returnedCard.texture = RandomCardTexture;
            returnedCard.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            returnedCard.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            returnedCard.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            returnedCard.run(SKAction.scaleX(to: 0.37, duration: 0.15))////////////// REMET A TAILLE NORMALE
            // ||
        }
        if (user != "StayDealer") && (user != "Returned") {
            run(SKAction.sequence([SKAction.run{returnedCard.run(vectorAction)},waitCardVector,swapCardSide]))
        }else if user == "Returned"{
            returnedCard.run(vectorAction)
        }
        
        return(returnedCard)
    }
    
    
    
    func funcReturnDealer(card : SKSpriteNode, CardNumber : Int, FamilyNumber : Int) -> SKSpriteNode{
        let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
        let RandomCardTexture = SKTexture(imageNamed: "\(CardNumber) \(family[FamilyNumber])")

        let swapCardSide = SKAction.run {
            card.run(SKAction.scaleX(to: 0.32, duration: 0.1));///// REDUIT UN PEU LA CARTE
            card.texture = RandomCardTexture;
            card.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            card.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            card.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            card.run(SKAction.scaleX(to: 0.37, duration: 0.15))

        }

        run(swapCardSide)
        return(card)
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
                    playerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: frame.midY-30, width: 60, height: 35),cornerRadius: 10)
                    playerScoreRect.fillColor = UIColor(red: 47/255, green: 69/255, blue: 83/255, alpha: 1.0)
                    playerScoreRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
                    addChild(playerScoreLabel)
                    addChild(playerScoreRect)
                    
            dealerScoreLabel.position = CGPoint (x: frame.midX, y: 2 * (frame.maxY/2.8))
                    dealerScoreLabel.text = "0"
                    dealerScoreLabel.fontSize = 23
            dealerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: 2 * (frame.maxY/2.8) - 10, width: 60, height: 35),cornerRadius: 10)
                    dealerScoreRect.fillColor = UIColor(red: 47/255, green: 69/255, blue: 83/255, alpha: 1.0)
                    dealerScoreRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
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
                //playercard1 = spawnRandomCard(user: "Player", xPos: 40, yPos: self.frame.midY - 50)
                //playercard2 = spawnRandomCard(user: "Player", xPos: 55, yPos: self.frame.midY - 65)
                //dealercard1 = spawnRandomCard(user: "Dealer", xPos: 40, yPos: self.frame.midY + 120)
                //dealercard2 = spawnRandomCard(user: "Dealer", xPos: 55, yPos: self.frame.midY + 105)
                let playerAction1 = SKAction.run {
                    _ = self.spawnRandomCard(user: "Player", xPos: -10, yPos: self.frame.maxY / 3.6 )
                    
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                        if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }
                
                let dealerCard1Action = SKAction.run {
                    _ = self.spawnRandomCard(user: "Dealer", xPos: -10, yPos: 2 * (self.frame.maxY / 3.6) );

                }
                let playerAction2 = SKAction.run {
                    _ = self.spawnRandomCard(user: "Player", xPos: 30 , yPos: self.frame.maxY / 3.6 - 10);
                    
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                    if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }

                let dealerCard2Action = SKAction.run {
                    self.DealerReturnedCard = self.spawnRandomCard(user: "Returned", xPos: 30, yPos: 2 * (self.frame.maxY / 3.6) - 10);
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
            }
    
            func hit(){
                disableUserInter(time: 1)
                let waitCard = SKAction.wait(forDuration: 0.7)
                let PlayerUpdate = SKAction.run{
                    self.updatePlayerScore()
                }
                playercard3 = spawnRandomCard(user : "Player", xPos: PlayerNewCardX, yPos: self.frame.maxY / 3.6 - PlayerNewCardY)
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
                if playerScore+playerHasAs == 21 {////////////////////////////////////
                    let wait = SKAction.wait(forDuration: 0.7)/////////// JOUEUR TIRE 21
                    isUserInteractionEnabled = false/////////////////////////////////////
                    let stayy = SKAction.run {
                        (self.stay())
                    }
                    run(SKAction.sequence([wait,stayy]))
                }
                PlayerNewCardX += 40
                PlayerNewCardY += 10
                
            }
            
    
            func stay(){
                var stayX : CGFloat!
                var stayY : CGFloat!
                
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
                        _ = self.spawnRandomCard(user: "Dealer", xPos: stayX, yPos:  2 * (self.frame.maxY / 3.6) - stayY)
                        stayX += 10
                        stayY += 10
                    }else{
                        self.gameOver = true
                        self.run(checkwinn)
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
                            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            node.run(Pressedbutton)
                            if StayTouched < 1{
                                StayTouched += 1
                                stay()
                            }
                        }
                    }
                }
            }
        }
