//
//  ArcheryScene.swift
//  SpriteKitDemo
//
//  Created by Alejandro Ferrero on 11/10/17.
//  Copyright © 2017 Alejandro Ferrero. All rights reserved.
//

import UIKit
import SpriteKit

class ArcheryScene: SKScene, SKPhysicsContactDelegate {

    private final let ballCount: Int = 20
    private final let arrowCategory: UInt32 = 0x1 << 0
    private final let ballCategory: UInt32 = 0x1 << 1
    private var score = 0
    
    override func didMove(to view: SKView) {
        let archeryNode = childNode(withName: "archerNode")
        archeryNode?.position.y = 0;
        archeryNode?.position.x = -self.size.width/2 + 40
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        self.physicsWorld.contactDelegate = self
        initArcheryScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let archerNode = childNode(withName: "archerNode") {
            let animate = SKAction(named: "animateArcher")
            let shootArrow = SKAction.run ({
                let arrowNode = self.createArrowNode()
                self.addChild(arrowNode)
                arrowNode.physicsBody?.applyImpulse(CGVector(dx: 60, dy: 0))
            })
            let sequence = SKAction.sequence([animate!, shootArrow])
            archerNode.run(sequence)
        }
        
    }
    
    private func initArcheryScene() {
        let releaseBalls = SKAction.sequence([SKAction.run({
          self.createBallNode()
        }), SKAction.wait(forDuration: 1)])
        self.run(SKAction.repeat(releaseBalls, count: ballCount), completion: {
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 5.0), SKAction.run({self.gameOver()})])
            self.run(sequence)
        })
    }
    
    private func createArrowNode() -> SKSpriteNode {
        let archerNode = childNode(withName: "archerNode")
        let archerWidth = archerNode?.frame.size.width
        
        let arrowNode = SKSpriteNode(imageNamed: "ArrowTexture.png")
        arrowNode.position = CGPoint(x: archerNode!.position.x + archerWidth!/3, y: archerNode!.position.y)
        arrowNode.name = "arrowNode"
        arrowNode.physicsBody = SKPhysicsBody(rectangleOf: arrowNode.frame.size)
        arrowNode.physicsBody?.usesPreciseCollisionDetection = true
        arrowNode.physicsBody?.categoryBitMask = arrowCategory
        arrowNode.physicsBody?.collisionBitMask = arrowCategory | ballCategory
        arrowNode.physicsBody?.contactTestBitMask = arrowCategory | ballCategory
    
        return arrowNode
    }
    
    private func createBallNode() {
        let ballNode = SKSpriteNode(imageNamed: "BallTexture.png")
        let screenWidth = self.size.width
        ballNode.position = CGPoint(x: randomBetween(min: -screenWidth/3, max: screenWidth/2-200), y: self.size.height-50)
        ballNode.name = "ballNode"
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: (ballNode.size.width/2))
        ballNode.physicsBody?.categoryBitMask = ballCategory
        ballNode.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(ballNode)
    }
    
    private func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let secondNode = contact.bodyB.node as! SKSpriteNode
        
        if (contact.bodyA.categoryBitMask == arrowCategory) && (contact.bodyB.categoryBitMask == ballCategory) {
            let contactPoint = contact.contactPoint
            let contact_y = contactPoint.y
            let target_x = secondNode.position.x
            let target_y = secondNode.position.y
            let margin = secondNode.frame.size.height/2 - 25
            
            if(contact_y > target_y - margin) && (contact_y < target_y + margin) {
                let burstPath = Bundle.main.path(forResource: "BurstParticle", ofType: "sks")
                if burstPath != nil {
                    let burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!) as! SKEmitterNode
                    burstNode.position = CGPoint(x: target_x, y: target_y)
                    secondNode.removeFromParent()
                    self.addChild(burstNode)
                    let burstAudio = SKAction(named:"audioAction")
                    burstNode.run(burstAudio!)
                }
                score += 1;
            }
        }
    }
    
    func createScoreNode() -> SKLabelNode {
        let scoreNode = SKLabelNode(fontNamed: "Bradley Hand")
        scoreNode.name = "scoreNode"
        
        let newScore = "Score: \(score)"
        
        scoreNode.text = newScore
        scoreNode.fontSize = 60
        scoreNode.fontColor = UIColor.blue
        scoreNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        return scoreNode
    }
    
    func gameOver() {
        let scoreNode = createScoreNode()
        self.addChild(scoreNode)
        let fadeOut = SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.fadeOut(withDuration: 3.0)])
        let welcomeReturn = SKAction.run ({
            let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
            let welcomeScene = GameScene(fileNamed: "GameScene")
            self.scene!.view?.presentScene(welcomeScene!, transition: transition)
        })
        let sequence = SKAction.sequence([fadeOut, welcomeReturn])
        self.run(sequence)
    }
}
