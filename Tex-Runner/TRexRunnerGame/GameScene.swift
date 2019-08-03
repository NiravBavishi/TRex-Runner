//
//  GameScene.swift
//  TRexRunnerGame
//
//  Created by Abita Shiney on 2019-02-08.
//  Copyright  2019 Abita Shiney. All rights reserved.
//cac

import SpriteKit
import GameplayKit
import AVFoundation
// struct PhysicsCategory {
// static let none      : UInt32 = 0
// static let all       : UInt32 = UInt32.max
// static let enemy1  : UInt32 = 0b1       // 1
// static let enemy2 : UInt32 = 0b10      // 2
// static let penguine : UInt32 = 0b100      // 4
// //static let enemy2 : UInt32 = 0b1000      // 8
// }

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let enemy2   : UInt32 = 0b1       // 1
    static let bullet: UInt32 = 0b10      // 2
    static let enemy1 : UInt32 = 0b100  //4
    static let penguine : UInt32 = 0b1000      // 8
    static let border : UInt32 = 0b10000 //16
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


class GameScene: SKScene{
    
    let penguin = SKSpriteNode(imageNamed: "icon_penguin" )
    var enemysDestroyed = 0
    //   let Enemy2 = SKSpriteNode()
    // let actualPlayfieldRect:CGRect
    let SHOW_BOUNDARIES = true
    private var Enemy2 = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []
    
    let jumpSound = SKAction.playSoundFileNamed("Tap.mp3", waitForCompletion: false)
    
    var gameOver = false
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    //  var highScore: Int
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var highScore = 0 {
        didSet {
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
   
    // override init(size: CGSize) {
    //     let maxAspectRatio:CGFloat = 16.0/9.0
    //
    //     let playfieldHeight = size.width / maxAspectRatio
    //     let margins = (size.height - playfieldHeight) / 2.0
    //
    ////     self.actualPlayfieldRect = CGRect(
    ////     x: 0,
    ////     y: margins,
    ////     width: size.width,
    ////     height: playfieldHeight)
    //
    //
    //     super.init(size:size)
    //
    //     }
    //
    
    //     func drawBoundaries() {
    //         let rect = SKShapeNode()
    //         let path = CGMutablePath()
    //         path.addRect(self.actualPlayfieldRect)
    //         rect.path = path
    //         rect.strokeColor = SKColor.magenta
    //         rect.lineWidth = 10.0
    //         addChild(rect)
    //     }
    
    
    // required init?(coder aDecoder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
    // }
    
    
    override func didMove(to view: SKView) {
        //MARK: back ground function
        //createbg()
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(createbg),
                SKAction.wait(forDuration: 9.0)
                ])
        ))
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = SKColor.black
        // scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.fontSize = 60
        scoreLabel.position = CGPoint(x: 200, y: 1000)
        addChild(scoreLabel)
        
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "Score: 0"
        highScoreLabel.fontColor = SKColor.black
        // scoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.fontSize = 60
        highScoreLabel.position = CGPoint(x: 800, y: 1000)
        addChild(highScoreLabel)
        
        //MARK: high score vlues
        
        var HighScoreDefault = UserDefaults.standard
        if(HighScoreDefault.value(forKey: "Highscore") != nil){
            highScore = HighScoreDefault.value(forKey: "Highscore") as! NSInteger
        }
        
        
        
        //add boundary around scene
        print("\(self.frame)")
        print("---------------\(view.frame)")
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.border
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self        //     self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //    self.name = "wall"
        //    self.physicsBody?.categoryBitMask = PhysicsCategory.border
        //
        //    self.physicsBody?.dynamic = true //This should be set to true
        //    self.physicsBody?.affectedByGravity = false
        //    self.physicsBody?.friction = 1
        
        //Add penguine
        penguin.position = CGPoint(x: 400, y: 270)
        penguin.size = CGSize(width: 140, height: 150)
        penguin.physicsBody?.affectedByGravity = true
        penguin.physicsBody?.isDynamic = false
        penguin.physicsBody = SKPhysicsBody(circleOfRadius: penguin.size.width/2)
        
        penguin.physicsBody?.categoryBitMask = PhysicsCategory.penguine
        penguin.physicsBody?.contactTestBitMask = PhysicsCategory.enemy1 | PhysicsCategory.enemy2 |  PhysicsCategory.border
        penguin.physicsBody?.collisionBitMask = PhysicsCategory.border
        //   penguin.physicsBody?.usesPreciseCollisionDetection = true
        addChild(penguin)
        // physicsWorld.gravity = CGVector(dx: 0.0, dy: -5)
        
        
        print("-------penguine\(penguin.position)")
        
        
        //setup boarder properties
        //    let borderBody = SKPhysicsBody(edgeLoopFrom: view.frame)
        //   // self.physicsBody = borderBody
        //    borderBody.friction = 0.0
        //    self.physicsBody?.categoryBitMask = PhysicsCategory.border
        //    borderBody.restitution = 1.0
        
        //  self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        
        //        var Enemy1Timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnEnemies1), userInfo: nil, repeats: true)
        //        var Enemy2Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnEnemies2), userInfo: nil, repeats: true)
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemies1),
                SKAction.wait(forDuration: 15.0)
                ])
        ))
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemies2),
                SKAction.wait(forDuration: 3.0)
                ])
        ))
       
        
    }
    
    var isMovingRight = true
    override func update(_ currentTime: TimeInterval) {
        
        self.penguin.position = CGPoint(x: self.penguin.position.x , y: self.penguin.position.y);
    }
    //MARK: spawn enemies
    func spawnEnemies1(){
        
        //Create sprite
        let Enemy1 = SKSpriteNode(imageNamed: "enemy1")
        
        //Adding masking values
        Enemy1.size = CGSize(width: 120, height: 150)
        Enemy1.physicsBody = SKPhysicsBody(rectangleOf: Enemy1.size) // 1
        Enemy1.physicsBody?.isDynamic = true // 2
        Enemy1.physicsBody?.categoryBitMask = PhysicsCategory.enemy1 // 3
        Enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.penguine // 4
        Enemy1.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        //name to the sprite
        Enemy1.name = "enemy1"
        //        let minValue = self.size.width / 8
        //        let maxValue = self.size.width - 150
        //  let spawnPoint1 = UInt32(maxValue - minValue)
        //position of the sprite
        Enemy1.position = CGPoint(x: self.size.width, y: 270)
        //add the sprite
        addChild(Enemy1)
        //speed of the sprite
        let actualDuration = random(min: CGFloat(14.0) , max:CGFloat(18.0))
        
        //create the action
        let action = SKAction.moveTo(x: 0, duration: TimeInterval(actualDuration))
        //remove after it is not visible
        let actionDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = OverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
            if(self.penguin.position.y == 500){
                self.penguin.texture = SKTexture(imageNamed: "icon_penguin")
            }
            print("pengine: \(self.penguin.position)")
        }
        Enemy1.run(SKAction.sequence([action,  actionDone]))
        
    }
    
    func spawnEnemies2(){
        //create sprite
        let Enemy2 = SKSpriteNode(imageNamed: "fly_1")
        //name the sprite
        Enemy2.name = "enemy2"
        
        
        //position of yhe sprite
        Enemy2.position = CGPoint(x: self.size.width, y: 580)
        Enemy2.size = CGSize(width: 120, height: 80)
        Enemy2.physicsBody = SKPhysicsBody(rectangleOf: Enemy2.size) // 1
        Enemy2.physicsBody?.isDynamic = true // 2
        Enemy2.physicsBody?.categoryBitMask = PhysicsCategory.enemy2 // 3
        Enemy2.physicsBody?.contactTestBitMask = PhysicsCategory.bullet // 4
        Enemy2.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        
        
        // add child
        //        if positionIsEmpty(point: Enemy2.position) {
        //            Enemy2.position = position
        addChild(Enemy2)
        // }
        //speed of the sprite
        let actualDuration = random(min: CGFloat(4.0) , max:CGFloat(8.0))
        
        //create the action
        let action = SKAction.moveTo(x: 0, duration: TimeInterval(actualDuration))
        
        //remove after it is not visible
        let actionDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = OverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        Enemy2.run(SKAction.sequence([action,  actionDone]))
    }
    
    // MARK: Random generation
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func positionIsEmpty(point: CGPoint) -> Bool {
        self.enumerateChildNodes(withName: "enemy1", using: {
            node, stop in
            
            let dot = node as! SKSpriteNode
            if (dot.frame.contains(point)) {
                print("no enemy")
            }
        })
        return true
    }
    
    //MARK: Background code
    func createbg() {
        let backgroundTexture = SKTexture(imageNamed: "bg-icebergs-1")
        
        //move background right to left; replace
        var shiftBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 9)
        
        //var replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y:0, duration: 0)
        var movingAndReplacingBackground = SKAction.repeatForever(SKAction.sequence([shiftBackground]))
        
        for i in 0 ... 3{
            //defining background; giving it height and moving width
            let background = SKSpriteNode(texture:backgroundTexture)
            background.zPosition = -2
            background.position = CGPoint(x: backgroundTexture.size().width/2 + (backgroundTexture.size().width * CGFloat(i)), y: self.frame.midY)
            background.size.height = self.frame.height
            background.run(movingAndReplacingBackground)
            
            self.addChild(background)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        if(touchLocation.x < penguin.position.x){
            jump()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        
        //
        print(penguin.position.x);
        print(touchLocation.x);
        
        // set the initial location of projectiles
        let bullet = SKSpriteNode(imageNamed: "ball")
        bullet.size = CGSize(width: 50, height: 50)
        bullet.position = penguin.position
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy2
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        // defining the offset
        let offset = touchLocation - bullet.position
        if(offset.x<0){
            return
        }
        addChild(bullet)
        let direction = offset.normalized()
        
        let throwRate = direction * 1000
        
        let destination = throwRate + (bullet.position)
        
        // adding and creating the action
        let action = SKAction.move(to: destination, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([action,actionDone]))
        
    }
    
    // MARK: Code for jump
    func jump() {
        penguin.texture = SKTexture(imageNamed: "penguin_jump02")
        penguin.physicsBody?.isDynamic = true
        //penguin.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        // move up 20
        let jumpUpAction = SKAction.moveBy(x: 0, y:270, duration:0.5)
        // move down 20
        let jumpDownAction = SKAction.moveBy(x:0, y:-270, duration:0.5)
        // sequence of move yup then down
        
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        run(jumpSound)
        // make player run sequence
        penguin.run(jumpSequence)
        
    }
    //MARK: when penguine collides with enemy
    func penguineDidCollidesEnemy(enemy: SKSpriteNode, penguine: SKSpriteNode) {
        print("You hit enemy1")
        //penguine.removeFromParent()
        enemy.removeFromParent()
        // enemysDestroyed += 1
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = OverScene(size: self.size, won: false)
        view?.presentScene(gameOverScene, transition: reveal)
        
        // gameOverFunc()
        
    }
    //MARK: penguin and enemy 2 collision
    func penguineDidCollidesEnemy2(enemy: SKSpriteNode, penguine: SKSpriteNode) {
//        let sound1 = SKAction.playSoundFileNamed("kill.mp3", waitForCompletion: true)
//        run(sound1)
        print("You hit enemy2")
        //penguine.removeFromParent()
        enemy.removeFromParent()
        //  enemysDestroyed += 1
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = OverScene(size: self.size, won: false)
        view?.presentScene(gameOverScene, transition: reveal)
        
    }
    
    //MARK: Bullet and enemy 2 collision
    func bulletDidCollidesEnemy2(enemy: SKSpriteNode, bullet: SKSpriteNode) {
        let sound2 = SKAction.playSoundFileNamed("killSound.mp3", waitForCompletion: false)
        run(sound2)
        print("Bullet hit enemy2")
        //penguine.removeFromParent()
        enemy.removeFromParent()
        enemysDestroyed += 1
        // score += 1
        score += 1
        
        if(score > highScore){
            highScore = score
            
            var HighScoreDefault = UserDefaults.standard
            HighScoreDefault.set(highScore, forKey: "Highscore")
            HighScoreDefault.synchronize()
            
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = OverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
    }
    
}
extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy1 != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.penguine != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let penguine = secondBody.node as? SKSpriteNode {
                penguineDidCollidesEnemy(enemy: enemy, penguine: penguine)
            }
        }
        else if ((firstBody.categoryBitMask & PhysicsCategory.enemy2 != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.bullet != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let bullet = secondBody.node as? SKSpriteNode {
                bulletDidCollidesEnemy2(enemy: enemy, bullet: bullet)
            }
        }
        else if ((firstBody.categoryBitMask & PhysicsCategory.enemy2 != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.penguine != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let penguine = secondBody.node as? SKSpriteNode {
                penguineDidCollidesEnemy2(enemy: enemy, penguine: penguine)
            }
        }
    }
}


