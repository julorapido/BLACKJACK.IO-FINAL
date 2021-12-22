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
        return(0)

    }
    func checkwin(){
        if dealerScore > 21 {
            won(alt: "DealerBust")
            DealerBusted = true
        }
        if dealerScore <= 21{
          if dealerScore < playerScore + playerHasAs{
                won(alt: "VICTORY")
                
            }
            }
        if dealerScore == playerScore+playerHasAs {
            push()
        }
        if DealerBusted == false {
            if dealerScore > playerScore+playerHasAs {
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
        
        
        if playerHasAs == PlayercardSpawned  {
            playerScore = playerHasAs+10
            playerScoreLabel.text = "\(playerScore)"
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
                run(SKAction.sequence([wait,stayy]))
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
    var DealerBusted = false
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
    
    var PlayerBusted = false
    var defo = UserDefaults.standard

    var DealerReturnedCard : SKSpriteNode!
    var playerHasOut10 = false

    
    var AlreadyWonLost = false
    var playerHas10onStart = 0
    var dealerHas10 = 0
    
    var zCardPositions : CGFloat!
    var addedValue : CGFloat!
    
    var  playerHasAsonStart = false
    var playercard10 = false

    let soundSpawnCard = SKAction.playSoundFileNamed("", waitForCompletion: false)
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
        let reveal = SKTransition.reveal(with: .right, duration: 0.33)
        comebackScene.scaleMode = .aspectFill
        view!.presentScene(comebackScene,transition: reveal)
    }
    func EndGameText(way:String){
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
        text.fontSize = 37
        text.position = CGPoint(x: frame.midX - 20, y: 5*(frame.maxY / 6))
        if way == "PlayerBust"{
            text.text = "YOU BUST"
            text.fontColor = UIColor.red
        }else if way == "Victory" {
            text.text = "WIN"
            text.fontColor = UIColor.green
        }else if way == "DealerWins" {
            text.text = "LOST"
            text.fontColor = UIColor.red
        }else if way == "Push"{
            text.text = "PUSH"
            text.fontColor = UIColor.orange
        }else if way == "blackjack"{
            text.text = "BLACKJACK"
            text.fontColor = UIColor.cyan
        }else if way == "DealerBust"{
            text.text = "DealerBust"
        }

        
        let addText = SKAction.run {
            self.addChild(text)
            text.alpha = CGFloat(0.3)
            text.yScale = CGFloat(0.8)
            text.xScale = CGFloat(0.7)
        }
        let fadein = SKAction.run {
            text.run(SKAction.fadeAlpha(to: 1, duration: 0.33))
            text.run(SKAction.scaleX(to: 1, duration: 0.33))
            text.run(SKAction.scaleY(to: 1, duration: 0.33))
        }
        let SpawnText = SKAction.run {
            self.run(SKAction.sequence([
                addText,
                fadein,
                SKAction.run {
                    self.addChild(effectsNode)
                }
            ]))
            
        }
        run(SKAction.sequence([SpawnText,wait,trans]))
    }
    
    
    func lost(way:String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        let previousExp = defo.integer(forKey: "UserExp")
        
        
        if way == "Bust"{
            EndGameText(way: "PlayerBust")
            if previousExp > 0 {
                defo.set(previousExp - 20 , forKey: "UserExp")
            }
            
        }else if way == "DealerBetterScore"{
            EndGameText(way: "DealerWins")
            if previousExp > 0 {
                defo.set(previousExp - 25, forKey: "UserExp")
            }
        }
    }

    func push(){
        AlreadyWonLost = true
        EndGameText(way: "Push")
    }
    
    
     
    func won(alt : String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        let previousExp = defo.integer(forKey: "UserExp")
        hitbutton.isUserInteractionEnabled = false
        staybutton.isUserInteractionEnabled = false

        
        if alt == "DealerBust"{
            if previousExp >= 0 {
                defo.set(40 + previousExp, forKey: "UserExp")
            }
            EndGameText(way: "DealerBust")

            
        }else if alt == "VICTORY"{

            EndGameText(way: "Victory")
            if previousExp >= 0 {
            defo.set(45 + previousExp, forKey: "UserExp")
            }

        }else if alt == "BLACKJACK"{
            EndGameText(way: "blackjack")
            if previousExp >= 0 {
                defo.set(60 + previousExp, forKey: "UserExp")
            }
        }
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func layoutScene(){
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

            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 13, height: frame.midY + 60), cornerRadius: 10)
            rect.position = CGPoint(x: frame.midX, y: frame.midY)
            rect.fillColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
            rect.lineWidth = CGFloat(3.5)
            rect.zPosition = -10
            addChild(rect)

        }

        func BottomRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 25, height: 3.5 * (frame.maxY/10)),cornerRadius: 35)
            rect.position = CGPoint(x: frame.midX, y: frame.minY)
            rect.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(7.5)
            addChild(rect)
        }
        
        func deck(){
            let deck = SKSpriteNode(imageNamed: "blue deck")
            deck.position = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 8.3)))
            deck.xScale = 0.23
            deck.yScale = 0.2
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
                    playerScoreRect.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
                    playerScoreRect.lineWidth = CGFloat(3)
                    playerScoreRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
                    addChild(playerScoreLabel)
                    addChild(playerScoreRect)
                    
                    dealerScoreLabel.position = CGPoint (x: frame.midX, y: 2 * (frame.maxY/2.8))
                    dealerScoreLabel.text = "0"
                    dealerScoreLabel.fontSize = 23
            
                    dealerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: 2 * (frame.maxY/2.8) - 10, width: 60, height: 35),cornerRadius: 10)
                    dealerScoreRect.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.4)
                    dealerScoreRect.strokeColor = UIColor(red: 25/255, green: 44/255, blue: 56/255, alpha: 1.0)
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
                
                if playerHasAsonStart == true && playerHas10onStart == 1 {
                    
                }
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
                if playerScore+playerHasAs == 21 && playerHasAsonStart == false && playerHas10onStart == 0{////////////////////////////////////
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
                        _ = self.spawnRandomCard(user: "Dealer", xPos: stayX, yPos:  2 * (self.frame.maxY / 3.6) - stayY)
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
                            if StayTouched < 1{
                                StayTouched += 1
                                stay()
                            }
                        }
                        }
                    }
                }
            }
        }
