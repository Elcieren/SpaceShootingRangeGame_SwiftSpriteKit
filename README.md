## CircleAnimateProgress
| Oyun Başlangıcı | | Oyun Bitti | 
|---------|---------|
| <img src="https://github.com/user-attachments/assets/ebf46e1d-e900-4d44-b28c-ec48274486ac" alt="Video 1" width="300"/> | <img src="https://github.com/user-attachments/assets/35caa6a5-8ee9-4cc4-9257-555a24868bad" alt="Video 1" width="300"/> |


 <details>
    <summary><h2>Uygulamanın Amacı</h2></summary>
    Proje Amacı
   Bu kod, bir uzay savaş oyununu simüle eden bir SpriteKit oyun sahnesi oluşturuyor. Oyuncu, belirli bir sürede ekranda beliren düşman nesneleri (uzaylılar) yok ederek puan topluyor. Geri sayım sona erdiğinde oyun bitiyor.Kod, oyuncuya ekrandaki düşmanları tıklayarak puan kazandıran bir oyun sahnesi oluşturur. Düşmanlar belli aralıklarla rastgele pozisyonlarda ekranda belirir ve oyuncu belirli düşmanları vurarak puan kazanır ya da kaybeder. 60 saniyelik süre dolduğunda oyun sona erer
  </details>  


  <details>
    <summary><h2>didMove(to:)</h2></summary>
     Bu fonksiyon, sahneye geçildiğinde ilk olarak çağrılır. Sahne ayarlarını yapar, düşmanların ortaya çıkması ve geri sayım için zamanlayıcıları başlatır.

    
    ```
     override func didMove(to view: SKView) {
    SetUpScene()
    }
    ```
  </details> 

  <details>
    <summary><h2>SetUpScene()</h2></summary>
    Sahneyi ayarlayan ana fonksiyondur. İşlevleri şunlardır:
    Arka planı siyah olarak ayarlar.
    Yıldız alanı efekti ekler (starfield), sahnede arka plan hareketi sağlar.
    Puan (scoreLabel) ve geri sayım (countdownLabel) etiketlerini ekler.
    Fiziksel dünya özelliklerini ayarlar.
    Düşman yaratma ve geri sayımı güncelleme zamanlayıcılarını başlatır.
    
    ```
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
    
    countdownLabel = SKLabelNode(fontNamed: "Chalkduster")
    countdownLabel.position = CGPoint(x: 900, y: 26)
    addChild(countdownLabel)
    
    score = 0
    countdown = 60
    countdownLabel.text = "Time: \(countdown)"
    
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(creatEnemy), userInfo: nil, repeats: true)
    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }




    
    ```
  </details> 


  <details>
    <summary><h2>updateCountdown()</h2></summary>
   Bu görünümde, üç Circular bileşeni iç içe eklenmiş durumda ve her biri farklı onTapGesture hareketlerine göre belirli bir yüzde değeri ile güncelleniyor:
    
    ```
    @objc func updateCountdown() {
    countdown -= 1
    countdownLabel.text = "Time: \(countdown)"
    
    if countdown <= 0 {
        gameTimer?.invalidate()
        countdownLabel.text = "Time's up!"
        isGamerOver = true
        showGameOverScreen()
    }
    }

    ```
  </details> 

  <details>
    <summary><h2>startGameTimer()</h2></summary>
   Düşman yaratma zamanlayıcısını başlatır ve timerInterval değerine göre sıklığını ayarlar.
    
    ```
    func startGameTimer() {
    gameTimer?.invalidate()
    gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(creatEnemy), userInfo: nil, repeats: true)
    }


    ```
  </details> 
  <details>
    <summary><h2>creatEnemy()</h2></summary>
   Rastgele bir düşman nesnesi oluşturur ve sahneye ekler. Düşmanların yaratılma sıklığını enemyCount ile ayarlar
    
    ```
    @objc func creatEnemy() {
    guard let enemy = possinleEnemies.randomElement() else { return }
    
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    sprite.name = enemy
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



    ```
  </details> 

  <details>
    <summary><h2>touchesBegan(_:with:)</h2></summary>
   Ekrana dokunulduğunda çağrılır. Dokunulan düşmanı tanır ve puan güncellemesi yapar. Oyun bitmişse yeni sahneye geçer
    
    ```
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



    ```
  </details> 

  <details>
    <summary><h2>showGameOverScreen()</h2></summary>
   Oyun bittiğinde bir "Game Over" ekranı gösterir.
    
    ```
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




    ```
  </details>

  <details>
    <summary><h2>stopGameTimer()</h2></summary>
   Zamanlayıcıyı durdurarak düşman yaratmayı sona erdirir.
    
    ```
    func stopGameTimer() {
    gameTimer?.invalidate()
     }

    ```
  </details>


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyun Başlangıcı</h4>
            <img src="https://github.com/user-attachments/assets/65b88b65-b15f-4184-b50e-2f76fc2cc439" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyun Bitiş Ekranı<</h4>
            <img src="https://github.com/user-attachments/assets/9924bc6b-47a0-4f6c-b192-14af5e00a540" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
