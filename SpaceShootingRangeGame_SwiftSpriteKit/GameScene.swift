//
//  GameScene.swift
//  SpaceShootingRangeGame_SwiftSpriteKit
//
//  Created by Eren Elçi on 6.11.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfiled: SKEmitterNode!
    var scoreLabel: SKLabelNode!
    var countdownLabel: SKLabelNode!  // Geri sayım etiketi
    var gameTimer: Timer?
    var possinleEnemies = ["alien-1", "al-1"]
    var enemyCount = 0
    var timerInterval = 1.0
    var countdown = 60  // 60 saniyelik geri sayım
    var isGamerOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        SetUpScene()
    }
    
    func SetUpScene() {
        backgroundColor = .black
        starfiled = SKEmitterNode(fileNamed: "starfield")!
        starfiled.position = CGPoint(x: 1024, y: 384)
        starfiled.advanceSimulationTime(10)
        addChild(starfiled)
        starfiled.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 100, y: 26)
        addChild(scoreLabel)
        
        countdownLabel = SKLabelNode(fontNamed: "Chalkduster")  // Geri sayım etiketi oluşturuluyor
        countdownLabel.position = CGPoint(x: 900, y: 26)
        addChild(countdownLabel)
        
        score = 0
        countdown = 60
        countdownLabel.text = "Time: \(countdown)"
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(creatEnemy), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)  // Her saniyede geri sayımı güncellemek için
    }
    
    @objc func updateCountdown() {
        countdown -= 1
        countdownLabel.text = "Time: \(countdown)"
        
        if countdown <= 0 {
            gameTimer?.invalidate()  // Düşman yaratmayı durdur
            countdownLabel.text = "Time's up!"
            isGamerOver = true
            showGameOverScreen()
            
        }
    }
    
    func startGameTimer() {
        gameTimer?.invalidate()  // Eski zamanlayıcıyı durdur
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(creatEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func creatEnemy() {
        guard let enemy = possinleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.name = enemy  // Düşmanın adını belirle (tıklama işleminde kullanmak için)
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        enemyCount += 1
        
        if enemyCount % 20 == 0 {
            timerInterval = max(0.1, timerInterval - 0.1)
            startGameTimer()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if let sprite = node as? SKSpriteNode, let enemyName = sprite.name {
                if enemyName == "alien-1" {
                    score += 100
                } else if enemyName == "al-1" {
                    score -= 200
                }
                sprite.removeFromParent()
            }
        }
        
        if isGamerOver {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    
    
    func showGameOverScreen() {
            if isGamerOver {
                let gameOver = SKSpriteNode(imageNamed: "gameovers")
                gameOver.position = CGPoint(x: 512, y: 384)
                gameOver.zPosition = 1
                gameOver.name = "game"
                addChild(gameOver)
                stopGameTimer()
            }
        }
    
    func stopGameTimer() {
            gameTimer?.invalidate()
        }
    
    
}

