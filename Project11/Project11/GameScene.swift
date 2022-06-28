//
//  GameScene.swift
//  Project11
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
	var scoreLabel: SKLabelNode!
	var editLabel: SKLabelNode!
	
	var score = 0 { didSet {
		scoreLabel.text = "Score: \(score)"
	}}
	
	var editingMode: Bool = false { didSet {
		if editingMode {
			editLabel.text = "Done"
			ballsCounter = 5
		} else {
			editLabel.text = "Edit"
		}
	}}
	
	var ballsCounter = 5
	
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)
		
		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.text = "Edit"
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
		
		makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
		makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
		
		makeBouncer(at: CGPoint(x: 0, y: 0))
		makeBouncer(at: CGPoint(x: 256, y: 0))
		makeBouncer(at: CGPoint(x: 512, y: 0))
		makeBouncer(at: CGPoint(x: 768, y: 0))
		makeBouncer(at: CGPoint(x: 1024, y: 0))
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		
		let listOfBalls = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
		let randomBall = listOfBalls[Int.random(in: 0..<listOfBalls.count)]
		
		let location = touch.location(in: self)
		let ball = 	SKSpriteNode(imageNamed: randomBall)
		let object = nodes(at: location)
		
		if object.contains(editLabel) {
			editingMode.toggle()
		} else {
			if editingMode {
				let size = CGSize(width: Int.random(in: 16...128), height: 16)
				let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
				box.zRotation = CGFloat.random(in: 0...3)
				box.position = location
				box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
				box.physicsBody?.isDynamic = false
				box.name = "draw"
				addChild(box)
			} else {
				ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
				ball.physicsBody?.restitution = 0.4
				ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
				ball.position = CGPoint(x: location.x, y: frame.height * 0.9)
				ball.name = randomBall
				if ballsCounter > 0 {
					ballsCounter -= 1
					addChild(ball)
				}
			}
		}
	}
	
	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
		bouncer.physicsBody?.isDynamic = false
		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode
		
		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "bad"
		}
		slotGlow.position = position
		slotBase.position = position
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false
		
		
		addChild(slotBase)
		addChild(slotGlow)
		
		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)
	}
	
	func collision(between ball: SKNode, object: SKNode) {
		
		if object.name == "draw" {
			object.removeFromParent()
		} else if object.name == "good" {
			score += scoreList(ballName: ball.name!)
			ballsCounter += 1
			destroy(ball: ball)
		} else if object.name == "bad" {
			score -= scoreList(ballName: ball.name!)
			destroy(ball: ball)
		}
	}
	
	func scoreList(ballName: String) -> Int {
		switch ballName {
		case "ballRed": return 1
		case "ballBlue": return 2
		case "ballCyan": return 3
		case "ballGreen": return 4
		case "ballGrey": return 5
		case "ballPurple": return 6
		case "ballYellow": return 7
		default: return 0
		}
	}
	
	func destroy(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = ball.position
			addChild(fireParticles)
		}
		ball.removeFromParent()
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
		guard let nameA = nodeA.name, let nameB = nodeB.name else { return }
		
		if nameA.contains("ball") {
			collision(between: nodeA, object: nodeB)
		} else if nameB.contains("ball") {
			collision(between: nodeB, object: nodeA)
		}
	}
}
