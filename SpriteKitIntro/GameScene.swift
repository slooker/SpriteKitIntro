//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Shawn Looker on 6/6/16.
//  Copyright (c) 2016 Shawn Looker. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var cannon: SKSpriteNode!
    var touchLocation: CGPoint = CGPointZero
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        cannon = self.childNodeWithName("cannon") as! SKSpriteNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")!.childNodeWithName("ball") as! SKSpriteNode
        ball.removeFromParent()
        self.addChild(ball)
        ball.position = cannon.position
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        // Get percentage of user moving finger across the screen
        let percent = touchLocation.x / size.width
        let newAngle = percent * 180 - 180
        
        // Rotate cannon
        cannon.zRotation = CGFloat(newAngle) * CGFloat(M_PI) / 180
        
        
        
    }
}
