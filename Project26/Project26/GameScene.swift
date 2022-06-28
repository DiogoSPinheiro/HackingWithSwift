//
//  GameScene.swift
//  Project26
//
//  Created by Diogo Santiago Pinheiro on 06/03/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
	case player = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
	case teleport = 32
}

class GameScene: SKScene {
	
	var player: SKSpriteNode!
	var lastTouchPosition: CGPoint?
	
	var motionManager: CMMotionManager?
	
	var scoreLabel: SKLabelNode!
	
	var score = 0 { didSet{
		scoreLabel.text = "Score: \(score)"
	}}
	
	var isGameOver = false
	
	var teleport = [CGPoint]()
	var isTeleporting = false
	
	var currentTeleport: CGPoint!
	
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.zPosition = 2
		addChild(scoreLabel)
		
		score = 0
		
		loadLevel()
		createPlayer()
		
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		
		motionManager = CMMotionManager()
		motionManager?.startAccelerometerUpdates()
	}
	
	func loadLevel() {
		guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else { fatalError("Not find level in bundle")
		}
		
		guard let levelString = try? String(contentsOf: levelURL) else {
			fatalError("Can't load level")
		}
		
		let lines = levelString.components(separatedBy: "\n")
		
		for (row, line) in lines.reversed().enumerated() {
			for (column, letter) in line.enumerated() {
				let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
				
				if letter == "x" {
					let node = SKSpriteNode(imageNamed: "block")
					node.position = position
					node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
					node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
					node.physicsBody?.isDynamic = false
					addChild(node)
					
				} else if letter == "v" {
					let node = SKSpriteNode(imageNamed: "vortex")
					node.name = "vortex"
					node.position = position
					node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					addChild(node)
					
				} else if letter == "s" {
					let node = SKSpriteNode(imageNamed: "star")
					node.name = "star"
					node.position = position
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					addChild(node)
					
				} else if letter == "f" {
					let node = SKSpriteNode(imageNamed: "finish")
					node.name = "finish"
					node.position = position
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.physicsBody?.isDynamic = false
					node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					addChild(node)
				} else if letter == "t" {
					let node = SKSpriteNode(imageNamed: "teleport")
					node.name = "teleport"
					node.position = position
					node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
					node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
					node.physicsBody?.isDynamic = false
					node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
					node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
					node.physicsBody?.collisionBitMask = 0
					addChild(node)
					teleport.append(position)
					
				} else if letter != " "{
					fatalError("Incorret letter input \(letter)")
				}
			}
		}
	}
	
	func createPlayer(position: CGPoint = CGPoint(x: 96, y: 672)) {
		player = SKSpriteNode(imageNamed: "player")
		player.position = position
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody?.allowsRotation = false
		player.physicsBody?.linearDamping = 0.5
		player.zPosition = 1
		
		player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
		
		player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
		addChild(player)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		lastTouchPosition = location
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		lastTouchPosition = location
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		lastTouchPosition = nil
	}
	
	override func update(_ currentTime: TimeInterval) {
		
		guard isGameOver == false else { return }
		
#if targetEnvironment(simulator)
		if let lastTouchPosition = lastTouchPosition {
			let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
			physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
		}
#else
		if let accelerometerData = motionManager?.accelerometerData {
			physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
		}
#endif
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if nodeA == player {
			playerCollided(with: nodeB)
		} else {
			playerCollided(with: nodeA)
		}
	}
	
	func playerCollided(with node: SKNode) {
		if node.name == "vortex" {
			player.physicsBody?.isDynamic = false
			isGameOver = true
			score -= 1
			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(to: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])

			player.run(sequence) { [weak self] in
				self?.createPlayer()
				self?.isGameOver = false
			}
		} else if node.name == "star" {
			node.removeFromParent()
		} else if node.name == "finish" {
			player.physicsBody?.isDynamic = false
			isGameOver = true
			let gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 368)
			gameOver.zPosition = 3
			addChild(gameOver)
			
		} else if node.name == "teleport" && !isTeleporting {
			let move = SKAction.move(to: node.position, duration: 0.25)
			let scale = SKAction.scale(to: 0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])
			var newPosition: CGPoint!
			
			for position in teleport {
				if position != player.position && currentTeleport != position {
					currentTeleport = position
					newPosition = position
					break
				}
			}
			
			isTeleporting = true
			
			player.run(sequence) { [weak self] in
				self?.createPlayer(position: newPosition)
				self?.isGameOver = false
			}
			
		} else {
			isTeleporting = false
		}
	}
}
