//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Alejandro Ferrero on 11/10/17.
//  Copyright © 2017 Alejandro Ferrero. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {}

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let welcomeNode = childNode(withName: "welcomeNode")
        if welcomeNode != nil {
            let fadeAway = SKAction.fadeOut(withDuration: 1.0)
            welcomeNode?.run(fadeAway, completion: {
                let doors = SKTransition.doorway(withDuration: 1.0)
                let archeryScene = ArcheryScene(fileNamed: "ArcheryScene")
                self.view?.presentScene(archeryScene!, transition: doors)
            })
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
