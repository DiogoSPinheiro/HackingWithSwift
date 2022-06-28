//
//  GameScene.swift
//  Challegen19-21
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
	var lines = 3
	var gameTimer: Timer!
	let yPosition = [220.0, 340, 460]
	var enemies = [SKSpriteNode]()
	var scoreLabel: SKLabelNode!
	var bulletsLabel: SKLabelNode!
	
	var gameOverTime: Timer!
	var gameOver = false
	
	var bullets = 0 { didSet {
		bulletsLabel.text = "Bullets: \(bullets)"
	}}
	
	var score = 0 { didSet {
		scoreLabel.text = "Score: \(score)"
	}}
	
    override func didMove(to view: SKView) {
    
		let curtains = SKSpriteNode(imageNamed: "curtains")
		let woodBackground = SKSpriteNode(imageNamed: "wood-background")
		
		backgroundColor = .white
		
		curtains.position = CGPoint(x: 512, y: 364)
		addChild(curtains)
		
		woodBackground.position = CGPoint(x: 512, y: 364)
		woodBackground.blendMode = .replace
		woodBackground.zPosition = -2
		addChild(woodBackground)
		
		bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
		bulletsLabel.fontSize = 44
		bulletsLabel.horizontalAlignmentMode = .left
		bulletsLabel.position = CGPoint(x: 660, y: 80)
		bulletsLabel.fontColor = .black
		bulletsLabel.zPosition = 1
		addChild(bulletsLabel)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.fontSize = 44
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 120, y: 80)
		scoreLabel.fontColor = .black
		scoreLabel.zPosition = 1
		addChild(scoreLabel)

		score = 0
		bullets = 6
		
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		
		gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
		
		creatElements(width: curtains.size.width)
    }
	
	func creatElements(width: CGFloat) {
		createLines(width: width, position: CGPoint(x: 512, y: yPosition[0]))
		createLines(width: width, position: CGPoint(x: 512, y: yPosition[1]))
		createLines(width: width, position: CGPoint(x: 512, y: yPosition[2]))
	}
	
	func createLines(width: CGFloat, position: CGPoint) {
		let sprite = SKSpriteNode(color: UIColor(red: 0.39, green: 0.26, blue: 0.12, alpha: 1), size: CGSize(width: width, height: 10))
		sprite.position = position
		sprite.zPosition = -1
		addChild(sprite)
	}
	
	func chooseDifficulty() -> Int {
		
		if score >= 20 {
			return 5
		} else if score >= 15 {
			return 4
		} else if score >= 10 {
			return 3
		} else if score > 5 {
			return 2
		}
		return 1
	}
	
	@objc func createTargets() {
		let targets = ["target0", "badtarget0"]
		let randomLine = yPosition.randomElement()! + 40
		let rightToLeft = randomLine == 340 + 40
		let randomTarget = Int.random(in: 0...1)
		let target = SKSpriteNode(imageNamed: targets[randomTarget])
		let newSize = CGSize(width: target.size.width / 1.5, height: target.size.height / 1.5)
		
		if gameOver { return }
		
		if gameOverTime == nil {
			gameOverTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setGameOver), userInfo: nil, repeats: false)
		}
		
		target.position = CGPoint(x: rightToLeft ? 860 : 170, y: randomLine)
		target.size = newSize
		
		target.physicsBody = SKPhysicsBody(texture: target.texture!, size: newSize)
		target.physicsBody?.categoryBitMask = 1
		target.physicsBody?.velocity = CGVector(dx: (rightToLeft ? -200 : 200) * chooseDifficulty(), dy: 0)
		target.physicsBody?.linearDamping = 0
		target.zPosition = -1
		
		if randomTarget == 0 {
		target.name = "goodTarget"
		} else {
			target.name = "badTarget"
		}
		
		addChild(target)
		enemies.append(target)
	}
	
	@objc func setGameOver() {
		
		let gameOverSprite = SKSpriteNode(imageNamed: "game-over")
		gameOverSprite.position = CGPoint(x: 529, y: 364)
		addChild(gameOverSprite)
		
		gameOver = true
		gameTimer.invalidate()
		gameOverTime.invalidate()
	}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let tappedLocation = nodes(at: location)
		
		if bullets == 0 { return }
		if gameOver { return }
		
		run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
		
		bullets -= 1
		
		if bullets == 0 {
			run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: true))
			Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
				self?.bullets = 6
			})
		}
		
		for node in tappedLocation {
			if node.name == "goodTarget" {
				score += 1
				node.removeFromParent()
			} else if node.name == "badTarget" {
				score -= 1
				node.removeFromParent()
			}
		}
     }
}

extension GameScene: SKPhysicsContactDelegate {
	override func update(_ currentTime: TimeInterval) {
		for node in children {
			if node.position.x > 860 || (node.position.x < 150 && node.name != nil) {
				node.removeFromParent()
			}
		}
	}
}
