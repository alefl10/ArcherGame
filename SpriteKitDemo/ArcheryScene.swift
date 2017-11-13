//
//  ArcheryScene.swift
//  SpriteKitDemo
//
//  Created by Alejandro Ferrero on 11/10/17.
//  Copyright © 2017 Alejandro Ferrero. All rights reserved.
//

import UIKit
import SpriteKit

class ArcheryScene: SKScene {

    private final let ballCount: Int = 20
    
    override func didMove(to view: SKView) {
        let archeryNode = childNode(withName: "archerNode")
        archeryNode?.position.y = 0;
        archeryNode?.position.x = -self.size.width/2 + 40
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
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
        self.run(SKAction.repeat(releaseBalls, count: ballCount))
    }
    
    private func createArrowNode() -> SKSpriteNode {
        let archerNode = childNode(withName: "archerNode")
        let archerWidth = archerNode?.frame.size.width
        
        let arrow = SKSpriteNode(imageNamed: "ArrowTexture.png")
        arrow.position = CGPoint(x: archerNode!.position.x + archerWidth!, y: archerNode!.position.y)
        arrow.name = "arrowNode"
        arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.frame.size)
        arrow.physicsBody?.usesPreciseCollisionDetection = true
    
        return arrow
    }
    
    private func createBallNode() {
        let ballNode = SKSpriteNode(imageNamed: "BallTexture.png")
        let screenWidth = self.size.width
        ballNode.position = CGPoint(x: randomBetween(min: -screenWidth/2, max: screenWidth/2-200), y: self.size.height-50)
        ballNode.name = "ballNode"
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: (ballNode.size.width/2))
        ballNode.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(ballNode)
    }
    
    private func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
}
