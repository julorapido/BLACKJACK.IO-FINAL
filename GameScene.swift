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
        
        print("delerhas as :"+String(dealerHasAs))
        if dealerHasAs == 0 { ///////////////// LE DEALER N'AS PAS D'AS
            dealerScoreLabel.text = "\(dealerScore)"
        }
        
        if dealerHasAs >= 1 {///////// LE DEALER A UN AS OU PLUS
            if dealerHasAs + dealerScore + 10 < 21 {//////////// 11 FAIT PAS BUST
                dealerScoreLabel.text = "\(dealerScore+dealerHasAs), \(dealerScore+10+dealerHasAs)"
            }else{///////////// LE 11 AS L'AURAIT FAIT BUST
                justdepasse11 = true
                if justdepasse11 == false {
                    dealerScore += dealerHasAs + 10
                    dealerScoreLabel.text = "\(dealerScore)"
                }else if justdepasse11 == true {//////////// RAJOUTE DES AS EGALE À 1
                    if vare == false {
                    vare = true
                    dealerScore += dealerHasAs
                    dealerScoreLabel.text = "\(dealerScore)"
                    }else if vare == true {
                        if noas == true {
                            print("LA CA DEVRAI RRR")
                            dealerScore += 1
                            dealerScoreLabel.text = "\(dealerScore)"
                        }else if noas == false{
                            dealerScoreLabel.text = "\(dealerScore)"
                        }
                    }
                }
            }

        }
        return(0)

    }
    func checkwin(){
        print("CHECKININWINWIN")
        if dealerScore > 21 {
            won(alt: "DealerBust")
        }
        if dealerScore <= 21{
            if playerScore + playerHasAs < dealerScore {
                    lost(way: "DealerBetterScore")
            }else if dealerScore < playerScore + playerHasAs{
                won(alt: "VICTORY")
                
            }
            }
        if dealerScore == playerScore+playerHasAs {
            push()
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
    
    var hitbutton : SKLabelNode!
    var staybutton : SKLabelNode!
    
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

        
        let wait = SKAction.wait(forDuration: 2)
        let trans = SKAction.run({self.transition()})

        if way == "Bust"{
            let playerBust = SKLabelNode(fontNamed: "TextaW00-Heavy")
            playerBust.text = "BUST"
            playerBust.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            playerBust.fontColor = UIColor.red
            
            let playerBustAction = SKAction.run({self.addChild(playerBust)})
            run(SKAction.sequence([playerBustAction,wait,trans]))
            
        }else if way == "DealerBetterScore"{
            let playerLost = SKLabelNode(fontNamed: "TextaW00-Heavy")
            playerLost.text = "DEALER WINS"
            playerLost.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            playerLost.fontColor = UIColor.red
            
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

        hitbutton.isUserInteractionEnabled = false
        staybutton.isUserInteractionEnabled = false
        let wait = SKAction.wait(forDuration: 2)
        let trans = SKAction.run({
            self.transition()})
        if alt == "DealerBust"{
            let WinDealerBustLabel = SKLabelNode(fontNamed:"TextaW00-Heavy")
            let WinningAction = SKAction.run({self.addChild(WinDealerBustLabel)})

            WinDealerBustLabel.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            WinDealerBustLabel.text = "DEALERBUST"
            WinDealerBustLabel.fontColor = UIColor.orange
            run(SKAction.sequence([WinningAction,wait,trans]))

            
        }else if alt == "VICTORY"{
            let WinningLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
            let WinninglabelAction = SKAction.run({self.addChild(WinningLabel)})

            WinningLabel.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            WinningLabel.text = "PLAYER WINS"
            WinningLabel.fontColor = UIColor.green
            run(SKAction.sequence([WinninglabelAction,wait,trans]))

        }else if alt == "BLACKJACK"{
            let BlackjackLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
            let BlackjackLabelAction = SKAction.run({self.addChild(BlackjackLabel)})
            
            BlackjackLabel.position = CGPoint(x: frame.midX, y: frame.maxY-80)
            BlackjackLabel.text = "blackjack bro"
            BlackjackLabel.fontColor = UIColor.green
            run(SKAction.sequence([BlackjackLabelAction,wait,trans]))
        }
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func layoutScene(){
        func rect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX, height: frame.midY/4))
            rect.position = CGPoint(x: frame.midX, y: frame.minY)
            rect.fillColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            rect.strokeColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            addChild(rect)
        }
        func hitfunc(){
            hitRect = SKShapeNode(rect: CGRect(x: frame.midX - 90, y: frame.minY + 90, width: 80, height: 45), cornerRadius: 3)
            hitRect.fillColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            hitRect.strokeColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            hitRect.name = "ButtonHIT"
            hitbutton = SKLabelNode(fontNamed: "TextaW00-Heavy")
            hitbutton.text = "HIT"
            hitbutton.position = CGPoint(x:frame.midX - 50, y: frame.minY + 100)
            hitbutton.name = "hitbutton"
            hitbutton.zPosition = 1
            addChild(hitbutton)
            addChild(hitRect)
            
        }
        func stayfunc(){
            stayRect = SKShapeNode(rect: CGRect(x: frame.midX + 2, y: frame.minY + 90, width: 105, height: 45), cornerRadius: 3)
            stayRect.fillColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            stayRect.strokeColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
            stayRect.name = "ButtonSTAY"
            staybutton = SKLabelNode(fontNamed: "TextaW00-Heavy")
            staybutton.text = "STAY"
            staybutton.position = CGPoint(x:frame.midX + 50, y: frame.minY + 100)
            staybutton.name = "staybutton"
            staybutton.zPosition = 1
            addChild(staybutton)
            addChild(stayRect)
        }
        func bjbaneer(){
            let baneer = SKSpriteNode(imageNamed: "blackjack2to3")
            baneer.position = CGPoint(x: frame.midX, y: frame.midY+30)
            baneer.xScale = 0.5
            baneer.yScale = 0.5
            addChild(baneer)
        }
        bjbaneer()
        hitfunc()
        stayfunc()
        rect()
        
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
        var randInt = Int.random(in: 2...14)///////////////////////////////////////////// RANDOMIZER
        let returnedCard = SKSpriteNode(imageNamed: "back")
        let randomCardAction = SKAction.run({self.addChild(returnedCard)})
        let RandomCardTexture = SKTexture(imageNamed: "card\(randInt)")

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
            


            print("dealer:" + String(dealerScore))

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
        returnedCard.xScale = 0.5
        returnedCard.yScale = 0.5
        returnedCard.zPosition = zCardPositions
        returnedCard.position = CGPoint(x: frame.maxX, y: frame.maxY)
        //let moveToPointX = SKAction.moveTo(x: xPos, duration: 0.5)
        //let moveToPointY = SKAction.moveTo(y: yPos, duration: 0.5)
        //let moveXandY = SKAction.sequence([moveToPointX,moveToPointY])
        let waitCardVector = SKAction.wait(forDuration: 0.55)
        let topleft = CGPoint(x:frame.maxX,y:frame.maxY)
        let CardPoint = CGPoint(x: xPos, y: yPos)
        let vector = CGVector(dx: CardPoint.x - topleft.x, dy: CardPoint.y - topleft.y)
        let vectorAction = SKAction.move(by: vector, duration: 0.4)
        let swapCardSide = SKAction.run {
            returnedCard.run(SKAction.scaleX(to: 0.4, duration: 0.1));///// REDUIT UN PEU LA CARTE
            returnedCard.texture = RandomCardTexture;
            returnedCard.run(SKAction.scaleX(to: -0.4, duration: 0))////////////// SPAWN CARTE EN MIROIR
            returnedCard.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            returnedCard.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            returnedCard.run(SKAction.scaleX(to: 0.5, duration: 0.15))
            // ||
        }
        if (user != "StayDealer") && (user != "Returned") {
            run(SKAction.sequence([SKAction.run{returnedCard.run(vectorAction)},waitCardVector,swapCardSide]))
        }else if user == "Returned"{
            returnedCard.run(vectorAction)
        }
        
        return(returnedCard)
    }
    
    
    
    func funcReturnDealer(card : SKSpriteNode, number : Int) -> SKSpriteNode{
        let RandomCardTexture = SKTexture(imageNamed: "card\(number)")


        let swapCardSide = SKAction.run {
            card.run(SKAction.scaleX(to: 0.4, duration: 0.1));///// REDUIT UN PEU LA CARTE
            card.texture = RandomCardTexture;
            card.run(SKAction.scaleX(to: -0.4, duration: 0))////////////// SPAWN CARTE EN MIROIR
            card.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            card.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            card.run(SKAction.scaleX(to: 0.5, duration: 0.15))

        }
        print("dealer as ass: "+String(dealerHasAs))
        print("dealer : "+String(dealerScore))
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
        PlayerNewCardX = 70
        PlayerNewCardY = 80
        
        DealerNewCardX = 70
        DealerNewCardY = 90
        print(self.frame.midY)
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
                    
                    dealerScoreLabel.position = CGPoint (x: frame.midX, y: frame.midY + 200)
                    dealerScoreLabel.text = "0"
                    dealerScoreLabel.fontSize = 23
                    dealerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: frame.midY + 190, width: 60, height: 35),cornerRadius: 10)
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
                    _ = self.spawnRandomCard(user: "Player", xPos: 40, yPos: self.frame.midY - 50);
                    
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                    if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }
                
                let dealerCard1Action = SKAction.run {
                    _ = self.spawnRandomCard(user: "Dealer", xPos: 40, yPos: self.frame.midY + 120);

                }
                let playerAction2 = SKAction.run {
                    _ = self.spawnRandomCard(user: "Player", xPos: 55, yPos: self.frame.midY - 65);
                    
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                    if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }

                let dealerCard2Action = SKAction.run {
                    self.DealerReturnedCard = self.spawnRandomCard(user: "Returned", xPos: 55, yPos: self.frame.midY + 105);
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
            }
    
            func hit(){
                disableUserInter(time: 1)
                let waitCard = SKAction.wait(forDuration: 0.7)
                let PlayerUpdate = SKAction.run{
                    self.updatePlayerScore()
                    
                }
                playercard3 = spawnRandomCard(user : "Player", xPos: PlayerNewCardX, yPos: frame.midY - PlayerNewCardY)
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
                PlayerNewCardX += 15
                PlayerNewCardY += 15
                
            }
            
    
            func stay(){
                var stayX : CGFloat!
                var stayY : CGFloat!
                
                stayX = 65
                stayY = 538.0
                updatePlayerScoreStayPressed()
                disableUserInter(time: 5)
                var randInt = Int.random(in: 2...14)/////////////////////////////////////////////////// RANDOMIZER
                let waitNextCard = SKAction.wait(forDuration: 0.7)
                
                
                let spawnReturnedCard = SKAction.run {
                    _ = self.funcReturnDealer(card: self.DealerReturnedCard, number: randInt)
                }
                let waitCardAnim = SKAction.wait(forDuration: 0.2)

                
                let returnUpdate = SKAction.run {
                    if randInt == 11 || randInt == 12 || randInt == 13{
                        randInt = 10
                        self.dealerScore += randInt
                    }else if randInt == 14 {
                        self.dealerHasAs += 1
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
                        _ = self.spawnRandomCard(user: "Dealer", xPos: stayX, yPos: stayY)
                        stayX += 15
                        stayY -= 15
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

                
                
                let down = SKAction.scale(to: 0.9, duration: 0.1)
                let up = SKAction.scale(to: 1, duration: 0.1)
                let PressedbuttoN = SKAction.sequence([down,up])
                
                for touch in touches {
                    
                    let location = touch.location(in: self)
                    let touchedNode = self.nodes(at: location)
                    
                    for node in touchedNode {
                        
                        if node.name == "ButtonHIT"{
                            node.run(PressedbuttoN)
                            if StayTouched == 0 {
                                if playerScore < 21 {
                                    hit()
                                    hitPressed += 1
                                }
                            }
                        }
                        else if node.name == "ButtonSTAY"{
                            node.run(PressedbuttoN)
                            if StayTouched < 1{
                                StayTouched += 1
                                stay()
                            }
                        }
                    }
                }
            }
        }
